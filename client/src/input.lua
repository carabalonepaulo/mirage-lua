--[[
Input:bind('keyboard', 'released', function(key, scan_code)
  print('keyreleased', key, scan_code)
end)

Input:bind('keyboard', 'textinput', function(char)
  print('textinput', char)
end)

Input:bind('mouse', 'released', function(x, y, button)
  print('mousereleased', x, y, button)
end)
]]
local Emitter = require 'src.emitter'

local Input = {
  emitters = {
    ['textinput'] = Emitter(),
    ['keyboard'] = Emitter(),
    ['mouse'] = Emitter()
  },

  bind = function(self, emitter_id, event, callback)
    self.emitters[emitter_id]:bind(event, callback)
  end,

  unbind = function(self, emitter_id, event, callback)
    self.emitters[emitter_id]:unbind(event, callback)
  end,

  onKeyReleased = function(self, key, scan_code)
    self.emitters.keyboard:emit('released', key, scan_code)
  end,

  onKeyPressed = function(self, key, scan_code, isrepeat)
    if isrepeat then
      self.emitters.keyboard:emit('repeated', key, scan_code)
    else
      self.emitters.keyboard:emit('pressed', key, scan_code)
    end
  end,

  onTextInput = function(self, char)
    self.emitters.keyboard:emit('textinput', char)
  end,

  onMouseReleased = function(self, x, y, button)
    self.emitters['mouse']:emit('released', x, y, button)
  end,

  onMousePressed = function(self, x, y, button)
    self.emitters['mouse']:emit('pressed', x, y, button)
  end
}

return Input
