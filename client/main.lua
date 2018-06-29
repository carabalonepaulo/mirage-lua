require 'src.loader'

Input:init()
Game:init()

function love.load(args)
  Game:load()
end

function love.update(dt)
  lovebird.update()
  Game:update(dt)
end

function love.draw()
  Game:draw()
end

function love.textinput(text)
  Input.text:add(text)
end