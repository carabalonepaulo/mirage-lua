local class = require 'lib.30log'
local binser = require 'lib.binser'
local enet = require 'enet'
local Header = require 'src.headers'

local Network = class 'Network'

function Network:init()
  self.host = enet.host_create()
  self.status = nil
end

function Network:connect(ip, port)
  self.status = 'connecting'
  self.server_peer = self.host:connect(ip..':'..tostring(port))
end

function Network:disconnect()
  self.server_peer:disconnect()
  self.host:flush()
end

function Network:send(header, ...)
  self.server_peer:send(binser.serialize(header, ...))
end

function Network:update(dt)
  local event = self.host:service()
  if event then
    if event.type == 'connect' then
      self.status = 'connected'
    elseif event.type == 'receive' then
      self:handleData(event.data)
    elseif event.type == 'disconnect' then
      self.status = nil
      Yui:call('login')
    end
  end
end

function Network:handleData(data)
  local data, len = binser.deserialize(data)
  local header = data[1]

  if header == Header.Login then
    self:handleLogin(data[2])
  end
end

function Network:askLogin(name, password)
  self:send(Header.Login, name, love.data.hash('sha256', password))
end

function Network:handleLogin(result)
  if result == 1 then
    Yui:call('admin')
  end
end

function Network:sendSaveRequest()
  self:send(Header.ASave)
end

function Network:sendShutdownRequest()
  self:send(Header.AShutdown)
end

return Network
