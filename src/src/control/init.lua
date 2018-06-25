Control = IEntity:extend {
  init = function(self, x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.events = {
      enter = Stack(),
      leave = Stack(),
      over = Stack()
    }
    self.mouseOver = false
    self.debug = true
    self.visible = false
  end,

  isMouseOver = function(self)
    local mx, my = love.mouse.getPosition()

    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
  end,

  emit = function(self, event)
    self.events[event]:each(function(callback)
      callback()
    end)
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
    else
      if self.mouseOver then
        self:emit('leave')
        self.mouseOver = false
      end
    end
  end,

  draw = function(self)
    if self.debug then
      self:drawDebug()
    end
  end,

  drawDebug = function(self)
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  end
}