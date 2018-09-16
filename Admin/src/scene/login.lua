local class = require 'lib.30log'
local LoginScene = class 'LoginScene'

local gw2 = love.graphics.getWidth() / 2

function LoginScene:init()
  self.input_name = { text = '' }
  self.input_pass = { text = '' }
end

function LoginScene:update(dt)
  if Network.status then
    Network:update(dt)
  end

  suit.Input(self.input_name, gw2 - 120, 30, 120, 30)
  suit.Input(self.input_pass, gw2 - 120, 70, 120, 30)

  if suit.Button('Entrar', gw2 + 20, 45, 100, 30).hit then
    if not Network.status then
      Network:connect('127.0.0.1', 5000)
    end
    Network:askLogin(self.input_name.text, self.input_pass.text)
  end
end

function LoginScene:draw()
  suit.draw()
end

return LoginScene
