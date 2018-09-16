local Header = require 'src.packet.headers'
local b64 = require 'libb64'

return function(self, player_index, data)
  local name, password = data[2], data[3]

  if self.ban_list:find('name', name) ~= nil then
    self:sendTo(player_index, Header.Login, 0)
    return
  end

  local players = self.players
  for i = 1, self.high_index do
    if players[i] and players[i].account and players[i].account.name == name then
      self:sendTo(player_index, Header.Login, 0)
      return
    end
  end

  local password = b64.encode(password)
  local account = self.accounts:first(function(account)
    return account.name == name and account.password == password
  end)
  if account then
    self.players[player_index]:login(account)
    self:sendTo(player_index, Header.Login, 1)
  else
    self:sendTo(player_index, Header.Login, 0)
  end
end
