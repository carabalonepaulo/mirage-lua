local Character = require 'src.character'
local Vector2 = require('lib.struct').Vector2
local Header = require 'src.network.headers'

return function(player, name)
  for i = 1, #Network.players do
    local player = Network.players[i]
    if player.character.name == name then
      table.remove(Network.players, i)
      break
    end
  end
end