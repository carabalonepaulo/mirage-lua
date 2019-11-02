local Character = require 'src.character'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.network.headers'

--[[ data = {
  name = '',
  color = { r, g, b },
  position = { x, y }
} ]]
return function(player, data)
  for i = 1, #data do
    local char = Character(data.name, data.color)
    char.position = Vector2(data.position.x, data.position.y)
    table.insert(Network.players, char)
  end
end