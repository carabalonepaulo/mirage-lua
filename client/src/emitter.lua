local Emitter = class('Emitter')

function Emitter:init()
  self.events = {}
end

function Emitter:bind(event_name, func)
  if not self.events[event_name] then
    self.events[event_name] = {}
  end
  table.insert(self.events[event_name], func)
end

function Emitter:unbind(event_name, func)
  if func then
    local callback_list = self.events[event_name]
    for i = 1, #callback_list do
      if callback_list[i] == func then
        table.remove(self.events[event_name], i)
        break
      end
    end
  else
    self.events[event_name] = {}
  end
end

function Emitter:emit(event_name, ...)
  local callback_list = self.events[event_name]
  if callback_list then
    for i = 1, #callback_list do
      callback_list[i](...)
    end
  end
end

return Emitter
