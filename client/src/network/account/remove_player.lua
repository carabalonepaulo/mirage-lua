local Character = require 'src.character'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.network.headers'

return function(index)
  Network.players[index] = nil
end