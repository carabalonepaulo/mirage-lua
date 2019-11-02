local ffi = require 'ffi'

ffi.cdef([[
  typedef struct Vector2 {
    float x, y;
  } Vector2;

  typedef struct Vector3 {
    float x, y, z;
  } Vector3;
]])

return {
  Vector2 = function(x, y)
    local vector = ffi.new('Vector2')
    vector.x = x or 0
    vector.y = y or 0
    return vector
  end,

  Vector3 = function(x, y, z)
    local vector = ffi.new('Vector3')
    vector.x = x or 0
    vector.y = y or 0
    vector.z = z or 0
    return vector
  end,

  struct = function(template)
    return function(new_values)
      local new_table = {}
  
      if template then
        for k, v in pairs(template) do
          new_table[k] = v
        end
      end
  
      if new_values then
        for k, v in pairs(new_values) do
          new_table[k] = v
        end
      end
      
      return new_table
    end
  end
}

--[[local Player = struct { name = nil }
local p1 = Player { name = 'Paulo' }
local p2 = Player { name = 'Pedro' }
local p3 = Player()
p3.name = 'Joana'

print(p1.name, p2.name, p3.name)]]