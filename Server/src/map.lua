local class = require 'lib.30log'
local Map = class 'Map'

function Map:init(map_name)
  self.name = map_name
  self.players = {}
  self.data = self:loadData()
  self.block_data = self:loadBlockLayer()
  self.blocked = {}
end

function Map:addPlayer(player)
  self.players[player.index] = player
  local pos = player.character.position
  self:denyBlockPassage(pos.x, pos.y)
end

function Map:removePlayer(player)
  local pos = player.character.position
  self:allowBlockPassage(pos.x, pos.y)
  self.players[player.index] = nil
end

function Map:denyBlockPassage(x, y)
  self.blocked[x] = self.blocked[x] or {}
  self.blocked[x][y] = false
end

function Map:allowBlockPassage(x, y)
  self.blocked[x] = self.blocked[x] or {}
  self.blocked[x][y] = true
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
  local tile_blocked = self.block_data[x + y * self.data.width] == 0
  if tile_blocked then
    return false
  elseif self.blocked[x][y] then
    return false
  end
  return true
end

return Map