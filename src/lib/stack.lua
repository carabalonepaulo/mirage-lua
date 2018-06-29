function Stack()
  return setmetatable({
    _stack = {},
    count = 0,

    clear = function(self)
      self._stack = {}
      self.count = 0
    end,

    push = function(self, obj)
      self.count = self.count + 1
      rawset(self._stack, self.count, obj)
    end,

    pop = function(self)
      self.count = self.count - 1
      return table.remove(self._stack)
    end,

    shift = function(self)
      self.count = self.count - 1
      return table.remove(self._stack, 1)
    end,

    each = function(self, callback)
      for i = 1, self.count do
        callback(rawget(self._stack, i), i)
      end
    end,

    map = function(self, callback)
      for i = 1, self.count do
        rawset(self._stack, i, callback(rawget(self._stack, i)))
      end
    end,

    where = function(self, callback)
      local stack = Stack()
      for i = 1, self.count do
        local value = rawget(self._stack, i)
        local r = callback(value, i)
        if r then
          stack:push(value)
        end
      end
      return stack
    end
  }, {
    __index = function(self, index)
      return rawget(self._stack, index)
    end,
  })
end

--[[local stack = Stack()
stack:push('Paulo')
stack:push('Fernando')
print(stack.count == 2 and stack.count == #stack._stack)
stack:pop()
print(stack.count == 1 and stack.count == #stack._stack)
stack:push('Soreto')
stack:push('Fernando')
print(stack:shift() == 'Paulo')
stack:map(function(name)
  return 'x'
end)
print(stack[1] == 'x')
stack:clear()
print(stack.count == 0 and stack.count == #stack._stack)]]