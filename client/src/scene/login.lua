local LoginScene = Scene:extend('LoginScene')

function LoginScene:init()
  LoginScene.super.init(self)

  local txt_user = TextInput(40, 360, 180, 20)
  local txt_pass = TextInput(40, 390, 180, 20, true)
  local btn_login = Button('Entrar', 120, 420, 100, 20)
  btn_login:on('click', function()
    if txt_user.text:len() > 5 and txt_pass.text:len() > 5 then
      Network:askLogin(txt_user.text, txt_pass.text)
    end
  end)

  self:addControls({ txt_user, txt_pass, btn_login })
end

function LoginScene:update(dt)
  LoginScene.super.update(self, dt)
  Network:update()
end

function LoginScene:draw()
  LoginScene.super.draw(self)
  love.graphics.print(Network.account_status, 0, 0)
end

return LoginScene
