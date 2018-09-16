local Scene = require('src.scene'):extend('TestScene')
local Map = require 'src.map'
local Panel = require 'src.control.panel'
local Button = require 'src.control.button'


function Scene:init()
  Scene.super.init(self)
  self.map = Map('map2')

  local panel = Panel('test', 100, 100)
  local button = Button('button', 0, 0)
  panel:addControl(button)

  local button2 = Button('button', 10, 10)
  self:addControls(panel, button2)
end

function Scene:draw()
  self.map:draw()
  Scene.super.draw(self)

  love.graphics.setColor(1, 1, 1)
  --[[love.graphics.print(string.format('FPS: %i', love.timer.getFPS()), 0, 0)
  love.graphics.print(string.format('Tilesets: %i', #self.map.tilesets), 0, 20)]]
end

return Scene
