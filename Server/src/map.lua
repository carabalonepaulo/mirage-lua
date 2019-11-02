local class = require 'lib.30log'
local Map = class 'Map'

function Map:init(map_name)
  self.name = map_name
  self.players = {}
  self.data = self:loadData()
  self.block = self:loadBlockLayer()
end

function Map:addPlayer(player)
  --print(string.format('Jogador #%i entrou no mapa "%s".', player.index, self.name))
  table.insert(self.players, player)
end

function Map:removePlayer(player)
  local players = self.players
  for i = 1, #players do
    if players[i] == player then
      table.remove(players, i)
      --print(string.format('Jogador #%i saiu do mapa "%s".', i, self.name))
    end
  end
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