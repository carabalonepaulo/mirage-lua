local LoginScene = require('src.scene'):extend('LoginScene')

-- controls
local Panel = require 'src.control.panel'
local TextInput = require 'src.control.text_input'
local Button = require 'src.control.button'

local font = love.graphics.getFont()

function LoginScene:init()
  LoginScene.super.init(self)
  self.background = {
    image = ImageCache:getBackground('login'),
    scale = {}
  }
  self.background.scale.x = love.graphics.getWidth() / self.background.image:getWidth()
  self.background.scale.y = love.graphics.getHeight() / self.background.image:getHeight()

  Network:askMotd()

  local txt_user = TextInput('text_input', 65, 32)
  local txt_pass = TextInput('text_input', 65, 62, true)
  local btn_login = Button('button', 145, 92)
  btn_login:on('click', function()
    if txt_user.text:len() > 5 and txt_pass.text:len() > 5 then
      Network:askLogin(txt_user.text, txt_pass.text)
    end
  end)

  local panel = Panel('login', 20, 438)
  panel:addControls(txt_user, txt_pass, btn_login)

  self:addControl(panel)
end

function LoginScene:update(dt)
  LoginScene.super.update(self, dt)
  Network:update()
end

function LoginScene:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.background.image, 0, 0, 0, self.background.scale.x, self.background.scale.y)
  LoginScene.super.draw(self)

  local x = love.graphics.getWidth() / 2 - font:getWidth(Network.motd) / 2
  love.graphics.print(Network.motd, x, 12)
end

return LoginScene
