local b64 = require 'libb64'
local Header = require 'src.packet.headers'
local Packet = require 'src.packet.packet'
local LoginPacket = Packet:extend 'LoginPacket'

function LoginPacket:handle(data)
  local name, password = data[2], data[3]

  if self.server.ban_list:find('name', name) ~= nil then
    self:sendTo(self.player_id, Header.Login, 0)
    return
  end

  local players = self.server.players
  for i = 1, self.server.high_index do
    if players[i] and players[i].account and players[i].account.name == name then
      self:sendTo(self.player_id, Header.Login, 0)
      return
    end
  end

  local password = b64.encode(password)
  local account = self.server.accounts:first(function(account)
    return account.name == name and account.password == password
  end)
  if account then
    self.server.players[self.player_id]:login(account)
    self:sendTo(self.player_id, Header.Login, 1)
  else
    self:sendTo(self.player_id, Header.Login, 0)
  end
end

return LoginPacket