return function(d)
  return function(t)
    local b = {}

    if d then
      for k, v in pairs(d) do
        b[k] = v
      end
    end

    if t then
      for k, v in pairs(t) do
        b[k] = v
      end
    end
    
    return b
  end
end

--[[local Player = struct { name = nil }
local p1 = Player { name = 'Paulo' }
local p2 = Player { name = 'Pedro' }
local p3 = Player()
p3.name = 'Joana'

print(p1.name, p2.name, p3.name)]]