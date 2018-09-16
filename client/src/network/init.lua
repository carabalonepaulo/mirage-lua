local class = require 'lib.30log'
local enet = require 'enet'
local binser = require 'lib.binser'
local pp = require 'lib.pp'
local Header = require 'src.network.headers'

local SUCCESS = 1
local FAIL = 0

local Network = class 'Network'

function Network:init()
  self.host = enet.host_create()
  self.account_status = 'unitialized'
  self.conn_status = 'none'
  self.motd = ''
  self.account = {}
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
  elseif header == Header.Motd then
    self:handleMotd(data[2])
  elseif header == Header.CharactersInfo then
    self:handleCharsInfo(data[2])
  end
end

function Network:askMotd()
  self:send(Header.Motd)
end

function Network:askLogin(name, password)
  self.account.name = name
  self:send(Header.Login, name, love.data.hash('sha256', password))
end

function Network:sendDeleteChar(char_index)
  self:send(Header.DeleteChar, char_index)
end

function Network:handleLogin(result)
  if result == SUCCESS then
    self.account_status = 'connected'
    Yui:call('account')
  else
    self.account_status = 'refused'
    self.account.name = nil
  end
end

function Network:handleMotd(motd)
  self.motd = motd
end

function Network:handleCharsInfo(chars)
  self.account.characters = chars
  -- se está na tela de seleção de char quando a informação chegou...
  if Yui.scene.name == 'AccountScene' then
    Yui.scene:resetControls()
  end
end

return Network
