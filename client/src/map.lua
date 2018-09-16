local class = require 'lib.30log'
local json = require 'lib.json'

local PFE = '([0-9A-Za-z-]+%.[a-z]+)'
local PF = '([0-9A-Za-z-]+)%.[a-z]+'

local Map = class 'Map'

function Map:init(map_name)
  self.data = json.decode(love.filesystem.read('data/maps/'..map_name..'.json'))
  self:loadTilesets()
end

function Map:loadTilesets()
  self.tilesets = {}
  local tilesets = self.data.tilesets
  for i = 1, #tilesets do
    local tileset_data_path = 'data/tilesets/'..tilesets[i].source:match(PFE)
    local tileset_data = json.decode(love.filesystem.read(tileset_data_path))
    tileset_data.image = tileset_data.image:match(PF)

    ImageCache:load('assets/tilesets/'..tileset_data.image..'.png')
    table.insert(self.tilesets, tileset_data)
  end
end

function Map:draw()
  -- ground
  self:drawLayer(1)
  self:drawLayer(2)

  -- players
  

  -- trees
  self:drawLayer(3)
end

function Map:drawLayer(layer_index)
  local tileset = ImageCache:getTileset(self.tilesets[1].image)
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
