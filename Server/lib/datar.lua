local class = require '30log'
local json = require 'cjson'

local Datar = class('Datar')

function Datar:init(file_name)
  self._data = {}
  self:load(file_name)
end

function Datar:save()
  local file = io.open(self._file_name, 'w+')
  file:write(#self._data > 0 and json.encode(self._data) or '')
  file:close()
end

function Datar:load(file_name)
  self._file_name = file_name
  local file = io.open(self._file_name, 'r')
  if file then
    self._data = json.decode(file:read('*all'))
    file:close()
  else
    self._data = {}
  end
end

function Datar:add(object)
  local template = self._template
  if template then
    local message = 'expected field "%s"'
    for i = 1, #template do
      local field_name = template[i][1]
      if not object[field_name] or
          type(object[field_name]) ~= template[i][2] then
        error(message:format(k))
      end
    end

    message = 'wrong number of fields\nexpect %i\nmatch %i'
    local key_count = 0
    for k, _ in pairs(object) do
      key_count = key_count + 1
    end
    if key_count ~= table.getn(template) then
      error(message:format(table.getn(template), key_count))
    end
  end

  self:insertRawObject(object)
end

function Datar:all()
  return self._data
end

function Datar:where(condition)
  local data_objs = self._data
  local result = {}
  for i = 1, #data_objs do
    if condition(data_objs[i]) then
      rawset(result, #result + 1, data_objs[i])
    end
  end
  return result
end

function Datar:find(object)
  local objects = self._data
  for i = 1, #objects do
    if objects[i] == object then
      return i
    end
  end
  return 0
end

function Datar:removeAll(condition)
  local new_objects = {}
  local old_objects = self._data
  for i = 1, #old_objects do
    if condition(old_objects[i]) == false then
      rawset(new_objects, #new_objects + 1, old_objects[i])
    end
  end
  self._data = new_objects
end

function Datar:insertRawObject(raw_data)
  rawset(self._data, #self._data + 1, raw_data)
end

function Datar:setTemplate(...)
  local template = {...}
  if #template == 1 and type(template[1][1]) == 'table' then
    self._template = template[1]
  else
    self._template = template
  end
end

return Datar
