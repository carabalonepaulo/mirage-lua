--local struct = require 'lib.struct'
local Map = require 'src.map'
local MapScene = require('src.scene'):extend('TestScene')

local GRID = { W = 32, H = 32, COLOR = { 0, 0, 0, .1 } }

local font = love.graphics.getFont()

function MapScene:init()
  MapScene.super.init(self)

  self.map = Map('map2')
end

function MapScene:update(dt)
  MapScene.super.update(self, dt)
  self.map:update(dt)
end

function MapScene:draw()
  love.graphics.clear(1, 1, 1, 1)

  self.map:draw()
  MapScene.super.draw(self)
end

return MapScene
