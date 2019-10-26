local class = require 'lib.30log'
local Packet = class 'Packet'

function Packet:init(server, player_id)
  self.server = server
  self.player_id = player_id
end

function Packet:handle(data)
end

function Packet:sendTo(...)
  self.server:sendTo(...)
end

function Packet:sendToAll(...)
  self.server:sendToAll(...)
end

return Packet