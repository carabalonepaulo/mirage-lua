local class = require 'lib.30log'
local Character = class 'Character'

function Character:init(name, color, map, position)
  self.name = name
  self.color = color

  self.map = map
  self.position = position
end

return Character