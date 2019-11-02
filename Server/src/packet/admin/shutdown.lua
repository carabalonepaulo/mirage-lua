return function(server, player, data)
  if not server.players[player.index]:isAdmin() then
    --server:ban(players[player_id].account.name)
    --server:forceDisconnect(player_id)
    return
  end
  server:shutdown()
end