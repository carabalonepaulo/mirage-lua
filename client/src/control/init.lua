-- Tanto a atualização quando a renderização dos controles só ocorre
-- quando ele está VISÍVEL (preciso lembrar disso).

local Control = class('Control')

function Control:init(x, y, width, height)
  self.x = x
  self.y = y
  self.z = 0
  self.width = width
  self.height = height
  self.visible = true
  self.events = {}

  -- uso interno somente
  self.mouse_over = false
  self.mouse_down = false


  --[[self:on('enter', function() print('enter') end)
  self:on('leave', function() print('leave') end)
  self:on('click', function() print('click') end)]]
end

function Control:getPosition()
  return self.x, self.y
end

function Control:getSize()
  return self.width, self.height
end

function Control:getDimensions()
  return self.x, self.y, self.width, self.height
end

function Control:on(event_name, callback)
  if not self.events[event_name] then
    self.events[event_name] = {}
  end
  table.insert(self.events[event_name], callback)
end

function Control:emit(event_name, ...)
  local callbacks = self.events[event_name]
  if not callbacks or #callbacks == 0 then
    return
  end
  for i = 1, #callbacks do
    callbacks[i](...)
  end
end

function Control:doEvents()
  local x, y = love.mouse.getPosition()
  if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
    if not self.mouse_over then
      self:emit('enter')
    end
    self.mouse_over = true
    if love.mouse.isDown(1) then
      self:emit('press')
      self.mouse_down = true
    elseif self.mouse_down then
      self:emit('click')
      self.mouse_down = false
    end
  else
    if self.mouse_over then
      self:emit('leave')
    end
    self.mouse_over = false

    if love.mouse.isDown(1) then
      self.mouse_down_out = true
    else
      self.mouse_down_out = false
    end
  end
end

function Control:update(dt)
  self:doEvents()
end

function Control:draw()

end

return Control
