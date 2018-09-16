local Control = require 'src.control'
local Button = Control:extend('Button')

local IMAGE_NORMAL = 1
local IMAGE_HOVER = 2

function Button:init(image_name, x, y)
  self.image_name = image_name
  self.images = {
    ImageCache:getControl(image_name),
    ImageCache:getControl(image_name..'_hover')
  }
  self.state = IMAGE_NORMAL

  Button.super.init(self, x, y, self.images[1]:getWidth(),
    self.images[1]:getHeight())

  self:on('enter', function() self.state = IMAGE_HOVER end)
  self:on('leave', function() self.state = IMAGE_NORMAL end)
end

function Button:draw()
  Button.super.draw(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.images[self.state], self:getScreenPosition())
end

return Button
