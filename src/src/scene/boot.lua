BootScene = Scene:extend {
  load = function(self)
    local button = Button('Algo', 50, 50, 1, 100, 20)
    button:on('click', function(args)
      print(args.button) -- 'left' or 'right'
      print(args.mouse.x, args.mouse.y)
    end)

    local button2 = Button('Algo', 75, 60, 2, 100, 20)

    self:add(button)
    self:add(button2)
  end,

  update = function(self, dt)
    Scene.update(self, dt)
    
  end,

  draw = function(self)
    Scene.draw(self)
    
  end
}