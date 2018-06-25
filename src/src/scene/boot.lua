BootScene = IEntity:extend {
  init = function(self)
    self.button = Button('Algo', 50, 50, 100, 20)
  end,

  update = function(self, dt)
    self.button:update(dt)
  end,

  draw = function(self)
    self.button:draw()
  end
}