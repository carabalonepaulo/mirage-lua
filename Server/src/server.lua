local class = require 'lib.30log'
local bit = require 'bit'
local ffi = require 'ffi'
local json = require 'cjson'
local pp = require 'pp'
local b64 = require 'libb64'
local log = require 'lib.log'
local fun = require 'lib.fun'
local bitser = require 'lib.bitser'
local utils = require 'lib.utils'
local enet = require 'lib.enet'

local Header = require 'src.packet.headers'
local PacketHandler = require 'src.packet.handler'
local PacketFactory = require 'src.packet.factory'
--PacketFactory[Header.Login](player_index, character)
local Player = require 'src.player'
local Map = require 'src.map'

local Server = class 'Server'

function Server:init()
  self.players = {}
  self.maps = {}

  self.high_index = 0
  self.free_indices = {}

  self.running = true
  self:load()
  self:setupHost()
end

function Server:getHighIndex()
  return self.high_index
end

function Server:load()
  local init = os.clock()
  table.insert(self.maps, Map('map2'))
  log.debug(string.format('Server initialized in %0.2fs', os.clock() - init))
end

function Server:save()
  --local init = os.clock()

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

function Server:processPackets()
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

function Server:update()
  self:processPackets()
end

function Server:findFreeIndex()
  if #self.free_indices > 0 then
    return table.remove(self.free_indices)
  else
    self.high_index = self.high_index + 1
    return self.high_index
  end
end

function Server:sendTo(player_index, header, data)
  local message = bitser.dumps({ header = header, data = data })
  local packet = enet.enet_packet_create(message, message:len() + 1,
    enet.ENET_PACKET_FLAG_RELIABLE)
  enet.enet_peer_send(self.players[player_index].peer, 0, packet)
end

function Server:sendToAll(header, data)
  local message = bitser.dumps({ header = header, data = data })
  local packet = enet.enet_packet_create(message, message:len() + 1,
    enet.ENET_PACKET_FLAG_RELIABLE)
  local players = self.players
  for i = 1, self.high_index do
    if players[i] then
      enet.enet_peer_send(players[i].peer, 0, packet)
    end
  end
end

function Server:sendToGroup(condition, header, data)
  local message = bitser.dumps({ header = header, data = data })
  local packet = enet.enet_packet_create(message, message:len() + 1,
    enet.ENET_PACKET_FLAG_RELIABLE)
  local players = self.players
  for i = 1, self.high_index do
    if players[i] and condition(players[i]) then
      enet.enet_peer_send(players[i].peer, 0, packet)
    end
  end
end

function Server:onConnect(peer)
  local address = peer.address
  local index = self:findFreeIndex()
  local ip = string.format('%d.%d.%d.%d',
    bit.band(address.host, 0xFF),
    bit.band(bit.rshift(address.host, 8), 0xFF),
    bit.band(bit.rshift(address.host, 16), 0xFF),
    bit.band(bit.rshift(address.host, 24), 0xFF))

  peer.data = ffi.cast('void*', index)
  self.players[index] = Player(index, ip, address.port, peer)
end

function Server:onReceive(peer, raw_data)
  local packet = bitser.loads(raw_data)
  local header = packet.header
  local player_index = tonumber(ffi.cast('int', peer.data))

  if PacketHandler[header] then
    PacketHandler[header](self, self.players[player_index], packet.data)
  else
    -- ban
  end
end

function Server:onDisconnect(peer)
  local index = tonumber(ffi.cast('int', peer.data))
  table.insert(self.free_indices, index)

  if self.players[index] then
    self.players[index]:logout()
    self.players[index] = nil
  end
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
