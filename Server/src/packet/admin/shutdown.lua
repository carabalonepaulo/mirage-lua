return function(self, player_index)
  if not self.players[player_index]:isAdmin() then
    self:ban(self.players[player_index].account.name)
    self:forceDisconnect(player_index)
    return
  end
  self:shutdown()
end
