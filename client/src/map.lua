local class = require 'lib.30log'
local json = require 'lib.json'
local Map = class 'Map'

function Map:init(map_name)
  self.name = map_name
  self.data = require('data.maps.'..map_name)
  self:loadTilesets()
end

function Map:loadTilesets()
  self.tilesets = {}
  local tilesets = self.data.tilesets
  for i = 1, #tilesets do
    local tileset_data_path = 'data/tilesets/'..tilesets[i].name..'.json'
    local tileset_data = json.decode(love.filesystem.read(tileset_data_path))

    ImageCache:load('assets/tilesets/'..tilesets[i].name..'.png')
    table.insert(self.tilesets, tileset_data)
  end
end

function Map:update(dt)

end

function Map:draw()
  -- ground
  self:drawLayer(1)
  self:drawLayer(2)

  -- players
  local players = Network.players
  for i = 1, #players do
    if players[i] then
      local char = players[i].character
      love.graphics.setColor(char.color)
      love.graphics.rectangle('fill', char.position.x * 32, char.position.y * 32, 32, 32)
    end
  end
  
  --[[local char = Network.character
  love.graphics.setColor(char.color)
  love.graphics.rectangle('fill', char.position.x * 32, char.position.y * 32, 32, 32)]]

  -- trees
  self:drawLayer(3)
end

function Map:drawLayer(layer_index)
  local tileset = ImageCache:getTileset(self.tilesets[1].name)
  local layer = self.data.layers[layer_index]
  local max = layer.height * layer.width

  local map_width = self.data.width
  local map_height = self.data.height
  local tile_width = self.data.tilewidth
  local tile_height = self.data.tileheight
  local tiles_horz = self.tilesets[1].columns

  local x, y = 0, 0
  for data_index = 1, max do
    local tile_id = layer.data[data_index]
    local tile_x = (tile_id - 1) % tiles_horz
    local tile_y = math.floor((tile_id - 1) / tiles_horz)

    local quad = love.graphics.newQuad(tile_x * tile_width, tile_y * tile_height,
      tile_width, tile_height, tileset:getDimensions())
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(tileset, quad, x * tile_width, y * tile_height)

    if x == map_width - 1 then
      y = y + 1
      x = 0
    else
      x = x + 1
    end
  end
end

return Map
