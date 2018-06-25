Game = {
  init = function(self)
    self.font = love.graphics.newFont('assets/fonts/OpenSans-Bold.ttf', 14)
    self.scene = BootScene()
  end,

  update = function(self, dt)
    self.scene:update(dt)
  end,

  draw = function(self)
    self.scene:draw()
  end,

  call = function(self, scene)
    self.scene = scene
  end
}