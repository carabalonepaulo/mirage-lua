Control = IEntity:extend {
  init = function(self, x, y, z, width, height)
    self.x = x
    self.y = y
    self.z = z
    self.width = width
    self.height = height
    self.events = {
      enter = Stack(),
      leave = Stack(),
      over = Stack()
    }
    self.mouseOver = false
    self.debug = true
    self.visible = true
    self.canvas = love.graphics.newCanvas(width, height)
    --self.canvas:renderTo(function() self:refresh() end)
  end,

  drawBegin = function(self)
    love.graphics.setCanvas(self.canvas)
  end,

  drawEnd = function(self)
    love.graphics.setCanvas()
  end,

  refresh = function(self)
  end,

  setX = function(self, x)
    self.x = x
  end,

  setY = function(self, y)
    self.y = y
  end,

  setZ = function(self, z)
    self.z = z
  end,

  isMouseOver = function(self)
    local mx, my = love.mouse.getPosition()

    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
  end,

  emit = function(self, event, ...)
    local args = {...}
    self.events[event]:each(function(callback)
      callback(unpack(args))
    end)
  end,

  on = function(self, event, callback)
    self.events[event]:push(callback)
  end,

  update = function(self, dt)
    if not self.visible then
      return
    end

    if self:isMouseOver() then
      if self.mouseOver then
        self:emit('over')
      else
        self:emit('enter')
        self.mouseOver = true
      end
      local buttons = { 'left', 'right' }
      for i = 1, 2 do
        if love.mouse.isDown(i) then
          self:emit('click', {
            button = buttons[i],
            mouse = {
              x = love.mouse.getX(),
              y = love.mouse.getY(),
            }
          })
        end
      end
    else
      if self.mouseOver then
        self:emit('leave')
        self.mouseOver = false
      end
    end
  end,

  draw = function(self)
    if self.canvas then
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(self.canvas, self.x, self.y)
    end
  end,
}