require 'src.loader'

function love.load(args)
  Game:init()
  print(Color['Aquamarine'])
end

function love.update(dt)
  Game:update(dt)
end

function love.draw()
  Game:draw()
end