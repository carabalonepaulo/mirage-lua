local json = require 'lib.json'

local file = io.open('colors.json', 'r')
local colors = json.decode(file:read('*all'))
file:close()

file = io.open('luacode.lua', 'w+')
file:write("Color = {\n")
for i = 1, #colors do
  local r, g, b = colors[1].rgb:match("%(([0-9]+), ([0-9]+), ([0-9]+)%)")
  file:write(string.format("[%q] = { %i, %i, %i },\n", colors[i].name, r, g, b))
  print(colors[i].name)
end
file:write("}\n")
file:close()