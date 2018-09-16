local AccountScene = require('src.scene'):extend('AccountScene')

local Panel = require 'src.control.panel'
local Button = require 'src.control.button'

local font = love.graphics.getFont()

function AccountScene:init()
  AccountScene.super.init(self)
  self.background = ImageCache:getBackground('clean')
  self:resetControls()
  self:loadSprites()
end

function AccountScene:hasChar(slot_index)
  local chars = Network.account.characters
  for i = 1, #chars do
    if chars[i][1] == slot_index then
      return true
    end
  end
  return false
end

function AccountScene:resetControls()
  local panel = Panel('chars', 150, 215)

  for i = 0, 4 do
    local text, action
    if self:hasChar(i + 1) then
      local btn_delete = Button('btn_delete_char', 6 + (i * 78) + (i * 22), 137)
      btn_delete:on('click', function()
        Network:sendDeleteChar(i + 1)
      end)

      panel:addControls(Button('btn_select_char', 6 + (i * 78) + (i * 22), 105),
        btn_delete)
    else
      local btn_create = Button('btn_create_char', 6 + (i * 78) + (i * 22), 120)
      btn_create:on('click', function()
        Yui:call('create_char', i + 1)
      end)

      panel:addControl(btn_create)
    end
  end

  self.controls = {}
  self:addControl(panel)
end

function AccountScene:loadSprites()
  self.sprites = {}
  local chars = Network.account.characters
  for i = 1, #chars do
    self.sprites[chars[i][2]] = ImageCache:getCharset(chars[i][2])
  end
end

function AccountScene:update(dt)
  AccountScene.super.update(self, dt)
  Network:update()
end

function AccountScene:drawCharInfo()
  love.graphics.setColor(1, 1, 1)
  local chars = Network.account.characters
  for i = 1, #chars do
    -- nome
    local index = chars[i][1] - 1
    local text = string.format('%s [%i]', chars[i][3], chars[i][4])
    local x = (161 + (index * 78) + (index * 22)) + 39 - font:getWidth(text) / 2
    love.graphics.print(text, x, 232)
    
    -- sprite
    local img = self.sprites[chars[i][2]]
    local quad = love.graphics.newQuad(0, 0, 32, 48, img:getDimensions())
    love.graphics.draw(img, quad, 183 + (index * 78) + (index * 22), 250)
  end
end

function AccountScene:draw()
  love.graphics.draw(self.background)
  AccountScene.super.draw(self)
  self:drawCharInfo()
end

return AccountScene
