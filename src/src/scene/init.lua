Scene = class {
  init = function(self)
    self.controls = List()
  end,

  add = function(self, control)
    self.controls:add(control)
    self:sortControls()
  end,

  remove = function(self, control)
    self.controls:remove(control)
  end,

  sortControls = function(self)
    table.sort(self.controls._items, function(a, b)
      return a.z < b.z
    end)
  end,

  update = function(self, dt)
    self.controls:each(function(control)
      control:update(dt)
    end)
  end,

  draw = function(self)
    self.controls:each(function(control)
      control:draw()
    end)
  end,
}