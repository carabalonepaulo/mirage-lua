Button = Control:extend {
  init = function(self, text, x, y, width, height)
    Control.init(self, x, y, width, height)

    self.text = love.graphics.newText(Game.font, text)
    self.textPosition = {
      self.x, --+ self.width / 2 - self.text:getWidth() / 2,
      self.y --+ self.height / 2 - self.text:getHeight() / 2
    }
  end,

  draw = function(self)
    Control.draw(self)

    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(self.text, self.textPosition.x, self.textPosition.y)
  end
}