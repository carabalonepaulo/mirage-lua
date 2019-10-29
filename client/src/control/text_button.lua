local g = love.graphics
local ceil = require('math').ceil
local Control = require 'src.control'
local TextButton = Control:extend('TextButton')

local font = love.graphics.getFont()
local State = {
  Normal = 1,
  Over = 2
}

function TextButton:init(text, x, y, width)
  self.skin = ImageCache:getControl('default')
  TextButton.super.init(self, x, y, width, self.skin:getHeight())
  self:setText(text)

  self.quads = {}
  self.canvas = {}
  for i = 1, 2 do
    table.insert(self.quads, self:getQuads(i - 1))
    table.insert(self.canvas, love.graphics.newCanvas(self.width, self.height))
    self:render(i)
  end

  self.state = State.Normal
  self.background_color = { 0.2, 0.2, 0.2 }
  self.text_color = { 1, 1, 1 }

  self:on('enter', function() self.state = State.Over end)
  self:on('leave', function() self.state = State.Normal end)
end

function TextButton:getText()
  return self.text.text
end

function TextButton:setText(text)
  self.text = self.text or {}
  self.text.text = text
  self.text.width = font:getWidth(text)
  self.text.x = self.width / 2 - self.text.width / 2
  self.text.y = self.height / 2 - font:getHeight() / 2
end

function TextButton:getQuads(skin_index)
  local img_w, img_h = self.skin:getDimensions()
  local skin_w = img_w / 2
  local rect_w, rect_h = img_w / 2 / 3, img_h / 3

  return {
    top = {
      left = love.graphics.newQuad(skin_w * skin_index, 0, rect_w, rect_h, img_w, img_h),
      center = love.graphics.newQuad(skin_w * skin_index + rect_w, 0, rect_w, rect_h, img_w, img_h),
      right = love.graphics.newQuad(skin_w * skin_index + rect_w * 2, 0, rect_w, rect_h, img_w, img_h)
    },

    middle = {
      left = love.graphics.newQuad(skin_w * skin_index, rect_h, rect_w, rect_h, img_w, img_h),
      center = love.graphics.newQuad(skin_w * skin_index + rect_w, rect_h, rect_w, rect_h, img_w, img_h),
      right = love.graphics.newQuad(skin_w * skin_index + rect_w * 2, rect_h, rect_w, rect_h, img_w, img_h)
    },

    bottom = {
      left = love.graphics.newQuad(skin_w * skin_index, rect_h * 2, rect_w, rect_h, img_w, img_h),
      center = love.graphics.newQuad(skin_w * skin_index + rect_w, rect_h * 2, rect_w, rect_h, img_w, img_h),
      right = love.graphics.newQuad(skin_w * skin_index + rect_w * 2, rect_h * 2, rect_w, rect_h, img_w, img_h)
    }
  }
end

function TextButton:render(state)
  love.graphics.setCanvas(self.canvas[state])

  local x, y, w, h = 0, 0, self.width, self.height
  local rect_w, rect_h = self.skin:getWidth() / 2 / 3, self.skin:getHeight() / 3
  local times = ceil((w - 2 * rect_w) / rect_w)

  love.graphics.clear(0, 0, 0, 0)

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.skin, self.quads[state].top.left, x, y)  
  love.graphics.draw(self.skin, self.quads[state].middle.left, x, y + rect_h)
  love.graphics.draw(self.skin, self.quads[state].bottom.left, x, y + 2 * rect_h)

  for i = 1, times do
    love.graphics.draw(self.skin, self.quads[state].top.center, x + i * rect_w, y)
    love.graphics.draw(self.skin, self.quads[state].middle.center, x + i * rect_w, y + rect_h)
    love.graphics.draw(self.skin, self.quads[state].bottom.center, x + i * rect_w, y + 2 * rect_h)
  end

  love.graphics.draw(self.skin, self.quads[state].bottom.right, x + w - rect_w, y + 2 * rect_h)
  love.graphics.draw(self.skin, self.quads[state].middle.right, x + w - rect_w, y + rect_h)
  love.graphics.draw(self.skin, self.quads[state].top.right, x + w - rect_w, y)

  love.graphics.print(self.text.text, self.text.x, self.text.y)

  love.graphics.setCanvas()
end

function TextButton:draw()
  TextButton.super.draw(self)
  love.graphics.draw(self.canvas[self.state], self.x, self.y)
end

return TextButton
