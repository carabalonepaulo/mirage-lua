Button = Control:extend {
  init = function(self, text, x, y, z, width, height)
    Control.init(self, x, y, z, width, height)
    self.events['click'] = Stack()

    self:setText(text)
    self:refresh()
  end,

  setText = function(self, text)
    self.text = text
    self.textData = love.graphics.newText(Game.font, text)
    self.textPos = Vector2(
      self.width / 2 - self.textData:getWidth() / 2,
      self.height / 2 - self.textData:getHeight() / 2
    )
  end,

  getText = function(self)
    return self.text
  end,

  refresh = function(self)
    self:drawBegin()
    love.graphics.clear()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', 0, 0, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(self.textData, self.textPos.x, self.textPos.y)
    self:drawEnd()
  end,
}