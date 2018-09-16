-- Yui is my scene manager >.<

local Yui = {
  scenes = {},
  stack = {},

  load = function(self, scene_name)
    self:register(scene_name, require('src.scene.'..scene_name))
  end,

  register = function(self, scene_name, scene_class)
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
  call = function(self, scene_name, ...)
    self.scene = self.scenes[scene_name](...)
    self.stack[scene_name] = self.scene
  end,

  -- muda a cena atual para alguma que JÁ FOI usada
  -- o estado da cena permanece o mesmo
  goTo = function(self, scene_name)
    self.scene = self.stack[scene_name]
  end
}

return Yui
