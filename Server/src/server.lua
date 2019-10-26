local class = require 'lib.30log'
local ffi = require 'ffi'
local json = require 'cjson'
local pp = require 'pp'
local b64 = require 'libb64'
local log = require 'lib.log'
local fun = require 'lib.fun'
local binser = require 'lib.binser'
local utils = require 'lib.utils'
local enet = require 'lib.enet'

local Header = require 'src.packet.headers'
local Packet = require 'src.packet'
local Player = require 'src.player'
local BanList = require 'src.banlist'
local Database = require 'src.database.json'

local Server = class 'Server'

function Server:init()
  self.players = {}
  self.high_index = 0
  self.free_indices = {}
  self.running = true
  self.database = Database()

  self:load()
  self:setupHost()
end

function Server:load()
  --local init = os.clock()

  log.debug('Loading classes...')
  self.classes = json.decode(utils.readFile('data/classes.json'))

  log.debug('Loading accounts...')
  self.accounts = self.database:loadAccounts()

  log.debug('Loading banned accounts...')
  self.ban_list = BanList()

  --log.debug(string.format('Server initialized in %0.2fs', os.clock() - init))
end

function Server:save()
  --local init = os.clock()

  log.debug('Saving accounts...')
  self.database:saveAccounts(self.accounts:toTable())

  log.debug('Saving banned accounts...')
  self.ban_list:save()

  --log.debug(string.format('Server saved in %0.2fs', os.clock() - init))
end

function Server:setupHost()
  if enet.enet_initialize() ~= 0 then
    error('An error occurred while initializing ENet.')
  end

  local addr = ffi.new('ENetAddress')
  addr.host = Settings.host == '*' and enet.ENET_HOST_ANY or Settings.host
  addr.port = Settings.port

  self.host = enet.enet_host_create(addr, Settings.max_players, 1,
    Settings.bandwidth.incoming, Settings.bandwidth.outgoing)

  if tonumber(ffi.cast('int', self.host)) == 0 then
    error('An error occurred while trying to create the host.')
  end
end

function Server:loop()
  while self.running do
    self:update()
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

function Server:findFreeIndex()
  if #self.free_indices > 0 then
    return table.remove(self.free_indices)
  else
    self.high_index = self.high_index + 1
    return self.high_index
  end
end

function Server:verifyPacketLength(player_index, expected, given)
  if expected ~= given + 1 then
    local player = self.players[player_index]
    self.ban_list:add('ip', player.ip)
    log.warn(string.format("IP '%s' added to ban list", player.ip))
    if player.account then
      self.ban_list:add('name', player.account.name)
      log.warn(string.format("User '%s' added to ban list", player.account.name))
    end
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
  local player = Player(self:findFreeIndex(), peer)
  peer.data = ffi.cast('void*', player.index)
  self.players[player.index] = player
end

function Server:onReceive(peer, data)
  local data, len = binser.deserialize(data)
  local header = data[1]
  local player_index = tonumber(ffi.cast('int', peer.data))

  if Packet[header] then
    local packet = Packet[header](self, player_index)
    packet:handle(data)
    packet = nil
  else
    -- ban
  end
end

function Server:onDisconnect(peer)
  local index = tonumber(ffi.cast('int', peer.data))
  table.insert(self.free_indices, index)
  self.players[index] = nil
end

function Server:ban(name)
  self.ban_list:add('name', name)
end

function Server:unban(name)
  --[[self.banned:removeAll(function(account)
    return account.name == name
  end)]]
end

function Server:forceDisconnect(player_index)
  enet.enet_peer_reset(self.players[player_index].peer, 0)
end

function Server:shutdown()
  local players = self.players
  for i = 1, self.high_index do
    if players[i] then
      enet.enet_peer_disconnect(players[i].peer, 0)
    end
  end
  enet.enet_host_flush(self.host)
  enet.enet_host_destroy(self.host)
  enet.enet_deinitialize()

  self:save()
  self.running = false
  os.exit(1)
end

return Server
