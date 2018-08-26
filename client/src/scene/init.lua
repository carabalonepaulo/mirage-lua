local setScissor = love.graphics.setScissor
local Scene = class 'Scene'

function Scene:init()
  self.debug = false
  self.controls = {}
end

function Scene:addControl(control)
  table.insert(self.controls, control)
  table.sort(self.controls, function(a, b) return a.z < b.z end)
end

-- Quando for preciso adicionar mais de um controle por chamada
-- isso evita a reordenação da lista a cada inserção.
function Scene:addControls(control_list)
  for i = 1, #control_list do
    table.insert(self.controls, control_list[i])
  end
  table.sort(self.controls, function(a, b) return a.z < b.z end)
end

function Scene:updateControls(dt)
  local controls = self.controls
  for i = 1, #controls do
    if controls[i].visible then
      controls[i]:update(dt)
    end
  end
end

function Scene:update(dt)
  self:updateControls(dt)
end

function Scene:drawControls()
  local controls = self.controls
  for i = 1, #controls do
    if controls[i].visible then
      setScissor(controls[i]:getDimensions())
      controls[i]:draw()
      setScissor()
    end
  end
end

function Scene:draw()
  self:drawControls()
end

return Scene
