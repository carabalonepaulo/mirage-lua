local Character = require 'src.character'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.network.headers'

return function(player, data)
  local other_player = {}
  other_player.index = data.index
  other_player.character = Character(data.name, data.color)
  other_player.character.map = player.character.map
  other_player.character.position = Vector2(data.position.x, data.position.y)
  
  table.insert(Network.players, other_player)
end