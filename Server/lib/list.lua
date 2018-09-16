local function List(array)
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
end
return List
--[[
local list = List()
list:add('Paulo')
list:add('Fernando')
print(list.count == 2)
print(list[1] == 'Paulo')
print(list[2] == 'Fernando')
print(list:remove('Fernando') == 'Fernando')
print(list.count == 1)
print(list[1] == 'Paulo')
list:clear()
print(list.count == 0)
for i = 1, 10 do
  list:add(i)
end
print(list.count == 10)

local nlist = list:where(function(value, index)
  return value >= 5
end)
print(nlist.count == 6)
print(nlist[1] == 5)
list = List({ 21, 22, 23, 24, 25, 31, 32, 33, 34, 35 })
print(list.count == 10)
print(list:first() == 21)
]]
