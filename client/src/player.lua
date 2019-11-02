local class = require 'lib.30log'
local Player = class 'Player'

function Player:init(index)
  self.index = index
  self.character = nil
end

return Player