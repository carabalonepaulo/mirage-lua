local TextInput = Control:extend('TextInput')
local font = love.graphics.getFont()
local backspace_delay = 0.05

function TextInput:init(x, y, width, height, hidden)
  TextInput.super.init(self, x, y, width, height)
  self.hidden = hidden or false
  self.active = false
  self.background_color = { 0.2, 0, 0 }
  self.text = ''
  self.last_backspace = backspace_delay

  Input:bind('keyboard', 'textinput', function(char)
    if self.active then
      self.text = self.text..char
    end
  end)

  self:on('click', function()
    self.active = true
    self.background_color = { 0.8, 0, 0 }
    love.keyboard.setTextInput(true)
  end)
end

-- Não preciso verificar se está visível pois isso já é feito
-- no componente 'pai'.
function TextInput:update(dt)
  TextInput.super.update(self, dt)


  if self.active then
    if self.mouse_down_out then
      self.active = false
      self.background_color = { 0.2, 0, 0 }
      love.keyboard.setTextInput(false)
    end
    if love.keyboard.isDown('backspace') and self.last_backspace > backspace_delay then
      self.text = self.text:sub(1, self.text:len() - 1)
      self.last_backspace = 0
    else
      self.last_backspace = self.last_backspace + dt
    end
  end
end

function TextInput:draw()
  TextInput.super.draw()
  local x, y, w, h = self:getDimensions()
  love.graphics.setColor(self.background_color)
  love.graphics.rectangle('fill', x, y, w, h)
  x = x + 5
  y = y + (h / 2 - font:getHeight() / 2)
  love.graphics.setColor(0.8, 0.8, 0.8)
  if self.hidden then
    love.graphics.print(string.rep('*', self.text:len()), x, y)
  else
    love.graphics.print(self.text, x, y)
  end
end

return TextInput
