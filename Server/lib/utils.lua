local function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

return {
  readFile = function(file_path)
    local file, data = io.open(file_path, 'r'), ''
    if file ~= nil then
      data = file:read('*all')
      file:close()
    end
    return data
  end,

  writeFile = function(file_path, data, mode)
    local mode = mode or 'w+'
    local file = io.open(file_path, mode)
    file:write(data)
    file:close()
  end,

  printf = function(template, ...)
    print(string.format(template, ...))
  end,

  instance = function(t, attr)
    local obj = clone(t)
    if attr ~= nil then
      for k, v in pairs(attr) do
        obj[k] = attr[k]
      end
    end
    return obj
  end
}
