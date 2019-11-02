local class = require 'lib.30log'
local Map = class 'Map'

function Map:init(map_name)
  self.name = map_name
  self.players = {}
  self.data = self:loadData()
  self.block = self:loadBlockLayer()
end

function Map:addPlayer(player)
  self.players[player.index] = player
end

function Map:removePlayer(player)
  self.players[player.index] = nil
end

function Map:getTileWidth()
  return self.data.tilewidth
end

function Map:getTileHeight()
  return self.data.tileheight
end

function Map:getWidth()
  return self.data.width
end

function Map:getHeight()
  return self.data.height
end

function Map:loadData()
  return require('data.maps.'..self.name)
end

function Map:loadBlockLayer()
  local layers = self.data.layers
  local len = #layers

  for i = 1, len do
    if layers[i].name == 'Block' then
      return layers[i].data
    end
  end
end

function Map:isPassable(x, y)
  return self.block[x + y * self.data.width] == 0
end

return Map