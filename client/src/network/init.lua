local enet = require 'enet'
local binser = require 'lib.binser'
local Header = require 'src.network.headers'

local SUCCESS = 1
local FAIL = 0

local Network = class 'Network'

function Network:init()
  self.host = enet.host_create()
  self.account_status = 'unitialized'
  self.conn_status = 'none'
end

function Network:connect(ip, port)
  self.conn_status = 'connecting'
  self.server_peer = self.host:connect(ip..':'..tostring(port))
end

function Network:disconnect()
  self.server_peer:disconnect()
  self.host:flush()
end

function Network:getStatus()
  return self.conn_status
end

function Network:send(header, ...)
  self.server_peer:send(binser.serialize(header, ...))
end

function Network:update(dt)
  local event = self.host:service()
  if event then
    if event.type == 'connect' then
      self.conn_status = 'connected'
      Yui:call('login')
    elseif event.type == 'receive' then
      self:handleData(event.data)
    elseif event.type == 'disconnect' then
      self.conn_status = 'none'
    end
  end
end

function Network:handleData(data)
  local data, len = binser.deserialize(data)
  local header = data[1]

  if header == Header.Login then
    self:handleLogin(data[2])
  elseif header == Header.Register then
  end
end

function Network:askLogin(name, password)
  self:send(Header.Login, name, love.data.hash('sha256', password))
end

function Network:handleLogin(result)
  if result == SUCCESS then
    self.account_status = 'connected'
  else
    self.account_status = 'refused'
  end
end

return Network
