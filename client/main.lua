require 'src.tiete'

function love.load()
  love.keyboard.setTextInput(false)

  Yui:load('boot')
  Yui:load('login')

  Yui:call('boot')
end

function love.update(dt)
  Yui:update(dt)
end

function love.draw()
  Yui:draw()
end

function love.quit()
  Network:disconnect()
end

function love.keypressed(key, scancode, isrepeat)
  Input:onKeyPressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
  Input:onKeyReleased(key, scancode)
end

function love.textinput(text)
  Input:onTextInput(text)
end

function love.mousereleased(x, y, button)
  Input:onMouseReleased(x, y, button)
end

function love.mousepressed(x, y, button)
  Input:onMousePressed(x, y, button)
end
