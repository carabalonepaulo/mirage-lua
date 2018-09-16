local class = require 'lib.30log'
local AdminScene = class 'AdminScene'

function AdminScene:update(dt)
  Network:update(dt)

  if suit.Button('Salvar', 20, 30, 100, 30).hit then
    Network:sendSaveRequest()
  end

  if suit.Button('Encerrar', 20, 70, 100, 30).hit then
    Network:sendShutdownRequest()
  end
end

function AdminScene:draw()
  suit.draw()
end

return AdminScene
