function Vector2(x, y)
  return setmetatable({
    x = x or 0,
    y = y or 0
  }, {
    __add = function(a, b)
      return Vector2(a.x + b.x, a.y + b.y)
    end,

    __sub = function(a, b)
      return Vector2(a.x - b.x, a.y - b.y)
    end,

    __mul = function(a, b)
      return Vector2(a.x * b.x, a.y * b.y)
    end,

    __div = function(a, b)
      return Vector2(a.x / b.x, a.y / b.y)
    end,
  })
end

function Vector3(x, y, z)
  return setmetatable({
    x = x or 0,
    y = y or 0,
    z = z or 0
  }, {
    __add = function(a, b)
      return Vector2(a.x + b.x, a.y + b.y, a.z + b.z)
    end,

    __sub = function(a, b)
      return Vector2(a.x - b.x, a.y - b.y, a.z - b.z)
    end,

    __mul = function(a, b)
      return Vector2(a.x * b.x, a.y * b.y, a.z * b.z)
    end,

    __div = function(a, b)
      return Vector2(a.x / b.x, a.y / b.y, a.z / b.z)
    end,
  })
end