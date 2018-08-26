local class = require '30log'
local ffi = require 'ffi'
local bit = require 'bit'
local json = require 'cjson'
local pp = require 'pp'
local b64 = require 'libb64'

local binser = require 'lib.binser'
local Header = require 'src.headers'
local Accounts = require 'src.model.accounts'

local dll = (require('lib.arch') == 64 and 'ENetX64' or 'ENetX86')
local NULL = ffi.cast('void*', ffi.new('int', 0))

local printf = function(template, ...)
  print(string.format(template, ...))
end

local file = io.open('lib/enet.h', 'r')
ffi.cdef(file:read('*all'))
file:close()
local enet = ffi.load('bin/'..dll..'.dll')

local readFile = function(file_path)
  local file = io.open(file_path, 'r')
  local data = file:read('*all')
  file:close()
  return data
end

local Server = class 'Server'

function Server:init()
  -- { peer = ..., address = 'ip:port' }
  self.players = {}
  self.high_index = 0
  self.free_indices = {}

  self:load()
  self:setupHost()
end

function Server:load()
  print('Loading settings...')
  self.settings = json.decode(readFile('data/settings.json'))

  print('Loading accounts...')
  self.accounts = Accounts()
end

function Server:setupHost()
  if enet.enet_initialize() ~= 0 then
    error('An error occurred while initializing ENet.')
  end

  local addr = ffi.new('ENetAddress')
  addr.host = self.settings.host == '*' and enet.ENET_HOST_ANY or self.settings.host
  addr.port = self.settings.port

  self.host = enet.enet_host_create(addr, self.settings.max_players, 1, 0, 0)
  if tonumber(ffi.cast('int', self.host)) == 0 then
    error('An error occurred while trying to create the host.')
  end
end

function Server:update()
  local event = ffi.new('ENetEvent')
  while enet.enet_host_service(self.host, event, 0) > 0 do
    if event.type == enet.ENET_EVENT_TYPE_CONNECT then
      self:onConnect(event.peer)
    elseif event.type == enet.ENET_EVENT_TYPE_RECEIVE then
      self:onReceive(event.peer, ffi.string(event.packet.data,
        event.packet.dataLength))
      enet.enet_packet_destroy(event.packet)
    elseif event.type == enet.ENET_EVENT_TYPE_DISCONNECT then
      self:onDisconnect(event.peer)
      event.peer.data = NULL
    end
  end
end

--[[
Encontrar o índice de um peer se tornou meio inútil já
que agora o índice do jogador fica salvo no campo 'data' do peer.
Mas vai que um dia eu precise usar isso né ¯\_(ツ)_/¯
]]
function Server:findPlayerIndex(peer)
  local players = self.players
  for i = 1, self.high_index do
    if players[i].peer == peer then
      return i
    end
  end
end

function Server:findFreeIndex()
  if #self.free_indices > 0 then
    return table.remove(self.free_indices)
  else
    self.high_index = self.high_index + 1
    return self.high_index
  end
end

function Server:verifyPacketLength(expected, given)
  if expected ~= given + 1 then
    error('unexpected packet size')
  end
end

function Server:sendTo(player_index, header, ...)
  local message = binser.serialize(header, ...)
  local packet = enet.enet_packet_create(message, message:len() + 1,
    enet.ENET_PACKET_FLAG_RELIABLE)
  enet.enet_peer_send(self.players[player_index].peer, 0, packet)
end

function Server:sendToAll(header, ...)
  local message = binser.serialize(header, ...)
  local packet = enet.enet_packet_create(message, message:len() + 1,
    enet.ENET_PACKET_FLAG_RELIABLE)
  local players = self.players
  for i = 1, self.high_index do
    if players[i] then
      enet.enet_peer_send(players[i].peer, 0, packet)
    end
  end
end

function Server:onConnect(peer)
  local host = peer.address.host
  local player = {
    index = self:findFreeIndex(),
    address = string.format('%d.%d.%d.%d:%d',
      bit.band(host, 0xFF),
      bit.band(bit.rshift(host, 8), 0xFF),
      bit.band(bit.rshift(host, 16), 0xFF),
      bit.band(bit.rshift(host, 24), 0xFF),
      peer.address.port
    ),
    peer = peer
  }
  peer.data = ffi.cast('void*', player.index)
  self.players[player.index] = player
end

function Server:onReceive(peer, data)
  local data, len = binser.deserialize(data)
  local header = data[1]
  local player_index = tonumber(ffi.cast('int', peer.data))

  if header == Header.Login then
    self:verifyPacketLength(len, 2)
    self:handleLogin(player_index, data[2], data[3])
  elseif header == Header.Register then
    self:verifyPacketLength(len, 3)
    self:handleRegister(player_index, data[2], data[3], data[4])
  elseif header == Header.Motd then
  end
end

function Server:onDisconnect(peer)
  local index = self:findPlayerIndex(peer)
  table.insert(self.free_indices, index)
  self.players[index] = nil
end

function Server:handleLogin(player_index, name, password)
  local password = b64.encode(password)
  local result = self.accounts:where(function(account)
    return account.name == name and account.password == password
  end)
  if #result ~= 0 then
    self:sendTo(player_index, Header.Login, 1)
  else
    self:sendTo(player_index, Header.Login, 0)
  end
end

function Server:handleRegister(player_index, name, password, email)
end

function Server:handleMotd()
end

function Server:close()
  enet.enet_host_destroy(self.host)
end

return Server
