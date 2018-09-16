local Scene = require('src.scene'):extend('CreateCharScene')

local Panel = require 'src.control.panel'
local Button = require 'src.control.button'
local TextInput = require 'src.control.text_input'

local json = require 'lib.json'
local font = love.graphics.getFont()

function Scene:init(char_index)
  Scene.super.init(self)
  self.background = ImageCache:getBackground('create_char')

  self.char_index = char_index
  self.current_class = 1
  self.current_sprite = 1
  self.sprites = {}

  self:loadClasses()
  self:loadSprites()
  self:resetControls()
end

function Scene:resetControls()
  self.controls = {}

  local btn_back = Button('back', 296, 388)
  btn_back:on('click', function() Yui:goTo('account') end)

  local btn_create = Button('create', 405, 388)
  local txt_name = TextInput('name_input', 304, 206)

  local btn_prev_class = Button('prev', 304, 260)
  btn_prev_class:on('click', function()
    self:prev('current_class', #self.classes)
    self.current_sprite = 1
  end)
  local btn_next_class = Button('next', 469, 260)
  btn_next_class:on('click', function()
    self:next('current_class', #self.classes)
    self.current_sprite = 1
  end)

  local btn_prev_sprite = Button('prev', 345, 337)
  btn_prev_sprite:on('click', function()
    self:prev('current_sprite', #self.classes[self.current_class].graphics)
  end)
  local btn_next_sprite = Button('next', 430, 337)
  btn_next_sprite:on('click', function()
    self:next('current_sprite', #self.classes[self.current_class].graphics)
  end)

  self:addControls(txt_name, btn_back, btn_create, btn_prev_class, btn_next_class,
    btn_prev_sprite, btn_next_sprite)
end

function Scene:prev(counter_name, max)
  if self[counter_name] == 1 then
    self[counter_name] = max
  else
    self[counter_name] = self[counter_name] - 1
  end
end

function Scene:next(counter_name, max)
  if self[counter_name] == max then
    self[counter_name] = 1
  else
    self[counter_name] = self[counter_name] + 1
  end
end

function Scene:loadClasses()
  self.classes = json.decode(love.filesystem.read('data/classes.json'))
end

function Scene:loadSprites()
  local classes = self.classes
  for i = 1, #classes do
    for j = 1, #classes[i].graphics do
      local file_name = classes[i].graphics[j]
      self.sprites[file_name] = ImageCache:getCharset(file_name)
    end
  end
end

function Scene:update(dt)
  Scene.super.update(self, dt)
  Network:update()
end

function Scene:draw()
  love.graphics.draw(self.background)
  Scene.super.draw(self)

  -- sprite
  local gfx = self.sprites[self.classes[self.current_class].graphics[self.current_sprite]]
  local quad = love.graphics.newQuad(0, 0, 32, 48, gfx:getDimensions())
  love.graphics.draw(gfx, quad, 384, 325)

  -- class
  local class_name = self.classes[self.current_class].name
  local x = 345 + 62 - font:getWidth(class_name) / 2
  love.graphics.print(class_name, x, 266)
  --345 469
end

return Scene
