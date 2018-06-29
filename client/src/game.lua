Game = {
  init = function(self)
    self.font = love.graphics.newFont('assets/fonts/OpenSans-Bold.ttf', 12)
    self.scene = BootScene()
  end,

  load = function(self)
    self.scene:load()
  end,

  update = function(self, dt)
    self.scene:update(dt)
  end,

  draw = function(self)
    self.scene:draw()
  end,

  call = function(self, scene)
    if self.scene ~= nil then
      self.scene:dispose()
    end
    self.scene = scene
  end
}