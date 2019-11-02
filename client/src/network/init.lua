local class = require 'lib.30log'
local enet = require 'enet'
local bitser = require 'lib.bitser'
local pp = require 'lib.pp'
local rand = love.math.random
local Header = require 'src.network.headers'
local Packet = require 'src.network.packet'
local Character = require 'src.character'

local SUCCESS = 1
local FAIL = 0

local Network = class 'Network'

function Network:init()
  self.host = enet.host_create()
  self.conn_status = 'none'

  self.index = nil
  self.players = {}
end

function Network:connect(ip, port)
  self.conn_status = 'connecting'
  self.server_peer = self.host:connect(ip..':'..tostring(port))
end

function Network:disconnect()
  if self.conn_status == 'connected' then
    self.server_peer:disconnect()
  end
  self.host:flush()
end

function Network:getStatus()
  return self.conn_status
end

function Network:send(header, data)
  self.server_peer:send(bitser.dumps({ header = header, data = data }))
end

function Network:update(dt)
  local event = self.host:service()
  if event then
    if event.type == 'connect' then
      self.conn_status = 'connected'
      self:login(tostring(rand(1000, 9999)), {
        rand(),
        rand(),
        rand()
      })
    elseif event.type == 'receive' then
      self:handleData(event.data)
    elseif event.type == 'disconnect' then
      self.conn_status = 'none'
    end
  end
end

function Network:handleData(data)
  local packet = bitser.loads(data)
  local header = packet.header

  print(header)

  if Packet[header] then
    Packet[header](packet.data)
  end
end

function Network:login(name, color)
  self:send(Header.Login, { name = name, color = color })
end

return Network
