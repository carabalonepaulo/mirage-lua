local g = love.graphics
local Control = require 'src.control'
local TextButton = Control:extend('TextButton')
local font = love.graphics.getFont()

function TextButton:init(text, x, y, width, height)
  TextButton.super.init(self, x, y, width, height)
  self.text = text
  self.background_color = { 0.2, 0.2, 0.2 }
  self.text_color = { 1, 1, 1 }

  self:on('enter', function() self.background_color = { 0.4, 0.4, 0.4 } end)
  self:on('leave', function() self.background_color = { 0.2, 0.2, 0.2 } end)
end

function TextButton:draw()
  TextButton.super.draw(self)
  local x, y, w, h = self:getDimensions()

  g.setColor(self.background_color)
  g.rectangle('fill', x, y, w, h)
  g.setColor(self.text_color)
  x = x + (w / 2 - font:getWidth(self.text) / 2)
  y = y + (h / 2 - font:getHeight() / 2)
  g.print(self.text, x, y)
end

return TextButton
