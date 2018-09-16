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
  end
}
