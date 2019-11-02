return {
  Stack = function()
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
  end,

  List = function(array)
    return setmetatable({
      _items = array or {},
      count = array and #array or 0,
  
      first = function(self, condition)
        if condition then
          for i = 1, self.count do
            local value = rawget(self._items, i)
            if condition(value) then
              return value
            end
          end
        else
          return self._items[1]
        end
      end,
  
      clear = function(self)
        self._items = {}
        self.count = 0
      end,
  
      add = function(self, obj)
        self.count = self.count + 1
        rawset(self._items, self.count, obj)
      end,
  
      each = function(self, callback)
        for i = 1, self.count do
          callback(rawget(self._items, i), i)
        end
      end,
  
      where = function(self, callback)
        local list = List()
        for i = 1, self.count do
          local value = rawget(self._items, i)
          if callback(value, i) then
            list:add(value)
          end
        end
        return list
      end,
  
      remove = function(self, obj)
        self.count = self.count - 1
        return table.remove(self._items, self:find(obj))
      end,
  
      find = function(self, obj)
        for i = 1, self.count do
          if rawget(self._items, i) == obj then
            return i
          end
        end
      end,
  
      removeat = function(self, index)
        self.count = self.count - 1
        return table.remove(self._items, index)
      end,
  
      toTable = function(self)
        return self._items
      end
    }, {
      __index = function(self, index)
        return rawget(self._items, index)
      end
    })
  end,

  Queue = function()
    return setmetatable({
      count = 0,
      _items = {},
  
      enqueue = function(self, obj)
        self.count = self.count + 1
        rawset(self._items, self.count, obj)
      end,
  
      dequeue = function(self)
        self.count = self.count - 1
        return table.remove(self._items, 1)
      end,
  
      find = function(self, obj)
        for i = 1, self.count do
          if obj == rawget(self._items, i) then
            return i
          end
        end
        return 0
      end,
  
      contains = function(self, obj)
        return self:find(obj) > 0
      end,
  
      peek = function(self)
        return rawget(self._items, 1)
      end,
  
      each = function(self, callback)
        for i = 1, self.count do
          callback(rawget(self._items, i))
        end
      end,
  
      clear = function(self)
        self._items = {}
        self.count = 0
      end
    }, {})
  end
}