local class = require 'lib.30log'
local ImageCache = class('ImageCache')

function ImageCache:init()
  self.images = {}
end

function ImageCache:load(file_name)
  self.images[file_name] = love.graphics.newImage(file_name)
end

function ImageCache:unload(file_name)
  self.images[file_name]:release()
end

function ImageCache:unloadAll()
  for _, image in pairs(self.images) do
    image:release()
  end
end

function ImageCache:get(file_name)
  if not self.images[file_name] then
    self:load(file_name)
  end
  return self.images[file_name]
end

function ImageCache:getBackground(name)
  return self:get(string.format('assets/backgrounds/%s.png', name))
end

function ImageCache:getCharset(name)
  return self:get(string.format('assets/charsets/%s.png', name))
end

function ImageCache:getControl(name)
  return self:get(string.format('assets/controls/%s.png', name))
end

function ImageCache:getPanel(name)
  return self:get(string.format('assets/panels/%s.png', name))
end

function ImageCache:getTileset(name)
  return self:get(string.format('assets/tilesets/%s.png', name))
end

return ImageCache
