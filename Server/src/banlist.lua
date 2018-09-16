local class = require 'lib.30log'
local json = require 'cjson'
local pp = require 'pp'

local BanList = class 'BanList'

function BanList:init()
  self:load()
end

function BanList:save()
  local file = io.open('data/banned.json', 'w+')
  file:write(json.encode(self.data))
  file:close()
end

function BanList:load()
  local file = io.open('data/banned.json', 'r')
  self.data = json.decode(file:read('*all'))
  file:close()
end

function BanList:find(_type, value)
  local list = self.data[_type]
  for i = 1, #list do
    if list[i] == value then
      return i
    end
  end
  return nil
end

function BanList:add(_type, value)
  table.insert(self.data[_type], value)
end

function BanList:remove(_type, value)
  local list = self.data[_type]
  local index = self:find(_type, value)
  if index then
    table.remove(self.data[_type], index)
  end
end

return BanList
