local Character = require 'src.character'
local Map = require 'src.map'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.network.headers'

return function(player, data)
  Network.index = data.index
  local char = Network.character
  char.map = Map(data.map_name)
  char.position = Vector2(data.position.x, data.position.y)

  Yui:call('map')
end