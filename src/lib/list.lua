function List()
  local mt = {
    __index = function(t, k) return rawget(t._items, k) end,
    __newindex = function(t, k, v) rawset(t, k, v) end
  }

  return setmetatable({
    _break = -1,
    _items = {},
    count = 0,

    clear = function(t)
      t._items = {}
      t.count = 0
    end,

    add = function(t, item)
      t.count = t.count + 1
      rawset(t._items, t.count, item)
    end,

    each = function(t, cb)
      for i = 1, t.count do
        if cb(rawget(t._items, i), i) == -1 then
          break
        end
      end
    end,

    where = function(t, cb)
      local nt = List()
      for i = 1, t.count do
        local value = rawget(t._items, i)
        local r = cb(value, i)
        if r then nt:add(value) end
      end
      return nt
    end,

    remove = function(t, x)
      table.remove(t._items, x)
    end,

    find = function(t, x)
      for i = 1, #t._items do
        if rawget(t._items, i) == x then
          return i
        end
      end
    end,

    removeif = function(t, cb)
    local rt, count = {}, 0
      for i = 1, t.count do
        if cb(rawget(t._items, i), i) then
          count = count + 1
          rawset(rt, count, i)
        end
      end

      for i = 1, count do table.remove(t._items, rt[i]) end
    end
  }, mt)
end

return List

--[[local t = {}
local l = List()

local bm = require 'benchmark'
local reporter = bm.bm(6)

function times(n, cb)
  for i = 1, n do cb() end
end

print '-----------------------------\nAdicionando itens:\n-----------------------------'
reporter:report(function()
  times(1e3, function()
    for i = 1, 1e4 do
      table.insert(t, i)
    end
    t = {}
  end)

  for i = 1, 1e4 do
    table.insert(t, i)
  end
end, 'table')

reporter:report(function()
  times(1e3, function()
    for i = 1, 1e4 do
      l:add(i)
    end
    l:clear()
  end)

  for i = 1, 1e4 do
    l:add(i)
  end
end, 'list')

print '\n-----------------------------\nIterando sobre valores\n-----------------------------'
reporter:report(function()
  local x = 0
  for i = 1, #t do
    x = math.sin(t[i])
  end
end, 'table')

reporter:report(function()
  local x = 0
  l:each(function(v) x = math.sin(v) end)
end, 'list')

print '\n-----------------------------\nRemovendo numeros impares:\n-----------------------------'
reporter:report(function()
  local rt = {}
  for i = 1, #t do
    if t[i] % 2 ~= 0 then
      table.insert(rt, i)
    end
  end

  for j = 1, #rt do table.remove(t, rt[j]) end
end, 'table')

reporter:report(function()
  l:removeif(function(v) return v % 2 ~= 0 end)
end, 'list')]]