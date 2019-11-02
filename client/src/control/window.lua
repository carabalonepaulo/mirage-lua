local Control = require 'src.control'
local Window = Control:extend 'Window'

local setScissor = love.graphics.setScissor
local SORT_FUNC = function(a, b) return a.z < b.z end

function Window:init(x, y, width, height)
  Window.super.init(self, x, y, width, height)

  self.skin = ImageCache:getControl('window')
  self.controls = {}
  self.quads = self:getQuads()
end

function Window:getQuads()
  local img_w, img_h = self.skin:getDimensions()
  
  -- border
  local border_x = img_w / 2
  local rect_w, rect_h = img_w / 2 / 10, img_h / 2 / 10

  return {
    love.graphics.newQuad(border_x, 0, rect_w, rect_h, img_w, img_h)
  }
end

function Window:addControl(control)
  control:setParent(self)
  table.insert(self.controls, control)
  table.sort(self.controls, SORT_FUNC)
end

-- self:addControls(control1, control2, control3, ..., controlN)
function Window:addControls(...)
  local controls = {...}
  for i = 1, #controls do
    controls[i]:setParent(self)
    table.insert(self.controls, controls[i])
  end
  table.sort(self.controls, SORT_FUNC)
end

function Window:updateControls(dt)
  local controls = self.controls
  for i = 1, #controls do
    if controls[i].visible then
      controls[i]:update(dt)
    end
  end
end

function Window:update(dt)
  self:updateControls(dt)
end

function Window:drawControls()
  local controls = self.controls
  for i = 1, #controls do
    local control = controls[i]
    if control.visible then
      setScissor(self.x + control.x, self.y + control.y, control:getSize())
      control:draw()
      setScissor()
    end
  end
end

function Window:draw()
  Window.super.draw(self)
  love.graphics.setColor(0, 0, 0, 0.8)
  love.graphics.rectangle('fill', self:getDimensions())

  love.graphics.setColor(1, 1, 1, 1)
  self:drawControls()
end

return Window
