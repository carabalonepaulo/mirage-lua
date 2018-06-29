-- evolbug 2017, MIT License
-- clasp - class library
local clasp = {
  init = function()
  end,

  extend = function(self, proto)
    local meta = {}
    local proto = setmetatable(proto or {}, {
      __index = self,
      __call = function(_, ...)
        local o = setmetatable({}, meta)
        o:init(...)
        return o
      end
    })
    meta.__index = proto
    for k, v in pairs(proto.__ or {}) do
      meta['__' .. k] = v
    end
    return proto
  end
}
class = setmetatable(clasp, {
  __call = clasp.extend
})
