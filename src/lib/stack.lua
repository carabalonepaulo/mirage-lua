function Stack()
  local mt = {
    __index = function(t, k) return rawget(t._stack, k) end,
    __newindex = function(t, k, v) rawset(t, k, v) end
  }
  return setmetatable({
    _stack = {},
    count = 0,

    clear = function(t)
      t._stack = {}
      t.count = 0
    end,

    push = function(t, item)
    t.count = t.count + 1
      rawset(t._stack, t.count, item)
    end,

    pop = function(t)
      t.count = t.count - 1
      return table.remove(t._stack)
    end,

    shift = function(t)
      t.count = t.count - 1
      return table.remove(t._stack, 1)
    end,

    each = function(t, cb)
      for i = 1, t.count do
        cb(rawget(t._stack, i), i)
      end
    end,

    map = function(t, cb)
      for i = 1, t.count do
        rawset(t._stack, i, cb(rawget(t._stack, i)))
      end
    end,

    where = function(t, cb)
      local nt = Stack()
      for i = 1, t.count do
        local value = rawget(t._stack, i)
        local r = cb(value, i)
        if r then nt:push(value) end
      end
      return nt
    end
  }, mt)
end

return Stack

--[[local bm = require 'benchmark'
local reporter = bm.bm(6)
local t = {}
local s = Stack()

reporter:report(function()
  for i = 1, 1e6 do
    table.insert(t, math.sin(i))
  end
end, 'table.insert\t')

reporter:report(function()  
  for i = 1, 1e6 do
    s:push(math.sin(i))
  end
end, 'stack:push\t')

print('\n')
reporter:report(function()
  for i = 1, #t do
    t[i] = math.sin(i)
  end
end, 'table loop\t')

reporter:report(function()
  s:map(function(v) return math.sin(v) end)
end, 'stack:map\t')

print('\n')
reporter:report(function()
  local nt = {}
  for i = 1, #t do
    if i % 2 == 0 then
      table.insert(nt, i)
    end
  end
  t = nt
end, 'table filter\t')

reporter:report(function()
  s:where(function(v) return v % 2 == 0 end)
end, 'stack:where\t')]]