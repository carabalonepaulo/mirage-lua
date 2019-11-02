local Player = require 'src.player'
local Character = require 'src.character'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.network.headers'

return function(data)
  local other_player = Player(data.index)
  other_player.character = Character(data.name, data.color)
  other_player.character.map = Network.players[Network.index].character.map
  other_player.character.position = Vector2(data.position.x, data.position.y)
  
  Network.players[other_player.index] = other_player
end