local function Queue()
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
return Queue
--[[local queue = Queue()
queue:enqueue('Paulo')
queue:enqueue('Fernando')
print(queue.count == 2)
print(queue._items[1] == 'Paulo')
print(queue._items[2] == 'Fernando')
print(queue:dequeue() == 'Paulo')
queue:enqueue('Linhares')
print(queue:find('Fernando') == 1)
print(queue:dequeue() == 'Fernando')
print(queue:dequeue() == 'Linhares')
print(queue.count == 0)]]
