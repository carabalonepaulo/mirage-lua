--[[
Eventos:
- enter: quando o cursor do mouse entra na área do objeto
- leave: quando o cursor do mouse sai da área do objeto
- press: quando o botão esquerdo do mouse é pressionado (e está sobre o objeto)
- click: quando o botão esquerdo do mouse é solto (após ter sido pressionado)

Variáveis de estado:
- mouse_over: quando o cursor do mouse está sobre o objeto
- mouse_down: quando o botão esquerdo do mouse está pressionado

Propriedades:
- x: posição do objeto no eixo horizontal
- y: posição do objeto no eixo vertical
- z: TODO
- width: largura do objeto
- height: altura do objeto
- visible: se o objeto estiver visível, então true, senão false

Getters:
- getPosition: x, y
- getSize: width, height
- getDimensions: x, y, width, height
]]
local class = require 'lib.30log'
local Control = class('Control')

function Control:init(x, y, width, height)
  self.x = x
  self.y = y
  self.z = 0
  self.width = width
  self.height = height
  self.visible = true
  self.parent = nil
  self.events = {}

  -- uso interno somente
  self.mouse_over = false
  self.mouse_down = false
end

function Control:getPosition()
  return self.x, self.y
end

function Control:getScreenPosition()
  if self.parent then
    local x, y = self.parent:getScreenPosition()
    return self.x + x, self.y + y
  else
    return self.x, self.y
  end
end

function Control:getSize()
  return self.width, self.height
end

function Control:getDimensions()
  return self.x, self.y, self.width, self.height
end

function Control:setParent(control)
  self.parent = control
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
  local mx, my = love.mouse.getPosition()
  local x, y = self.x, self.y

  if self.parent then
    x = x + self.parent.x
    y = y + self.parent.y
  end

  if mx > x and mx < x + self.width and my > y and my < y + self.height then
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
