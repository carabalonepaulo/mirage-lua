-- Yui is my scene manager <3
local Yui = {
  scenes = {},

  load = function(self, scene_name)
    self:register(scene_name, require('src.scene.'..scene_name))
  end,

  register = function(self, scene_name, scene_class)
    --[[if self.scenes[scene_name] then
      self.scenes[scene_name]:unload()
    end]]
    self.scenes[scene_name] = scene_class
  end,

  update = function(self, dt)
    self.scene:update(dt)
  end,

  draw = function(self)
    self.scene:draw()
  end,

  -- muda a cena atual para uma pré-carregada
  -- o ctor da cena fica armazenado em uma lista
  -- e toda vez que chamar "call" a cena é resetada
  call = function(self, scene_name)
    self.scene = self.scenes[scene_name]()
  end,
}

return Yui
