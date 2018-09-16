local Control = require 'src.control'
local Panel = Control:extend('Panel')
local setScissor = love.graphics.setScissor

local SORT_FUNC = function(a, b) return a.z < b.z end

function Panel:init(image_name, x, y)
  self.background = ImageCache:getPanel(image_name)
  self.controls = {}

  Panel.super.init(self, x, y, self.background:getWidth(),
    self.background:getHeight())
end

function Panel:addControl(control)
  control:setParent(self)
  table.insert(self.controls, control)
  table.sort(self.controls, SORT_FUNC)
end

-- self:addControls(control1, control2, control3, ..., controlN)
function Panel:addControls(...)
  local controls = {...}
  for i = 1, #controls do
    controls[i]:setParent(self)
    table.insert(self.controls, controls[i])
  end
  table.sort(self.controls, SORT_FUNC)
end

function Panel:updateControls(dt)
  local controls = self.controls
  for i = 1, #controls do
    if controls[i].visible then
      controls[i]:update(dt)
    end
  end
end

function Panel:update(dt)
  self:updateControls(dt)
end

function Panel:drawControls()
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

function Panel:draw()
  Panel.super.draw(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.background, self:getPosition())

  self:drawControls()
end

return Panel
