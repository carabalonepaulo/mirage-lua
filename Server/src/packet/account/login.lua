local rand = require('math').random
local Character = require 'src.character'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.packet.headers'

return function(server, player, data)
  local player_id = player.index

  local char = Character(data.name, data.color)  
  char.map = server.maps[1]
  char.position = Vector2(
    rand(0, char.map:getWidth() - 1),
    rand(0, char.map:getHeight() - 1)
  )

  server.players[player_id]:login(char)

  -- envia informações do jogador para o client
  server:sendTo(player_id, Header.Login, {
    index = player_id,
    map_name = char.map.name,
    position = {
      x = char.position.x,
      y = char.position.y
    }
  })

  -- envia todos os jogadores no mapa para o client
  local players = {}
  local map_players = char.map.players
  for i = 1, #map_players do
    local character = map_players[i].character

    if character ~= char then
      server:sendTo(player_id, Header.AddPlayer, {
        index = map_players[i].index,
        name = character.name,
        color = character.color,
        position = {
          x = character.position.x,
          y = character.position.y
        }
      })
    end
  end

  -- envia as informações do jogador para todos no mesmo mapa
  server:sendToGroup(function(player)
    if player.character then
      return player.character.map == char.map
    else
      return false
    end
  end, Header.AddPlayer, {
    index = player_id,
    name = char.name,
    color = char.color,
    position = { x = char.position.x, y = char.position.y }
  })
end