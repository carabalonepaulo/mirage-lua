local Character = require 'src.character'
local Player = require 'src.player'
local Map = require 'src.map'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.network.headers'

return function(data)
  Network.index = data.index

  local c = data.character
  local char = Character(c.name, c.color)
  char.map = Map(c.map_name)
  char.position = Vector2(c.position.x, c.position.y)

  Network.index = data.index
  Network.players[data.index] = Player(data.index)
  Network.players[data.index].character = char

  Yui:call('map')
end