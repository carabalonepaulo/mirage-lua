Yui = require 'src.yui'
Network = require('src.network')()
suit = require 'lib.suit'

function love.load()
  Yui:load('login')
  Yui:load('admin')
  Yui:call('login')
end

function love.update(t)
  Yui:update(dt)
end

function love.draw()
  Yui:draw()
end

function love.textinput(t)
  suit.textinput(t)
end

function love.keypressed(key)
  suit.keypressed(key)
end
