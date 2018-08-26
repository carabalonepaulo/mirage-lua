local BootScene = Scene:extend('BootScene')

function BootScene:init()
  BootScene.super.init(self)
  Network:connect('127.0.0.1', 5000)
end

function BootScene:update(dt)
  BootScene.super.update(self, dt)
  Network:update()
end

function BootScene:draw()
  BootScene.super.draw(self)
  love.graphics.print('Status: '..Network:getStatus(), 0, 0)
end

return BootScene
