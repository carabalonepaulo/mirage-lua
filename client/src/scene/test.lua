local TextButton = require 'src.control.text_button'
local Scene = require('src.scene'):extend('TestScene')

function Scene:init()
  Scene.super.init(self)

  local button = TextButton('Teste', 50, 50, 100)

  self:addControl(button)
end

function Scene:draw()
  love.graphics.clear(50 / 255, 125 / 255, 168 / 255)
  
  Scene.super.draw(self)
end

return Scene
