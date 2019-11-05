local rand = require('math').random
local Character = require 'src.character'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.packet.headers'
local PacketFactory = require 'src.packet.factory'

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
  server:sendTo(player_id, Header.Login,
    PacketFactory[Header.Login](player_id, char))

  -- envia todos os jogadores no mapa para o client
  local players = {}
  local map_players = char.map.players
  for i = 1, #map_players do
    if map_players[i] then
      local character = map_players[i].character
      if character ~= char then
        server:sendTo(player_id, Header.AddPlayer,
          PacketFactory[Header.Login](map_players[i].index, character))
      end
    end
  end

  -- envia as informações do jogador para todos no mesmo mapa
  server:sendToGroup(function(player)
    if player.character then
      return player.character.map == char.map
    else
      return false
    end
  end, Header.AddPlayer, PacketFactory[Header.Login](player_id, char))
end