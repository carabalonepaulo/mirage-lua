local class = require 'lib.30log'
local Vector2 = require('lib.struct').Vector2
local Character = class 'Character'

function Character:init(name, color)
  self.name = name
  self.color = color

  self.map = nil
  self.position = nil
end

return Character