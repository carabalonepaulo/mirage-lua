local Header = require 'src.packet.headers'
local Packet = require 'src.packet.packet'
local MotdPacket = Packet:extend 'MotdPacket'

function MotdPacket:handle(data)
  self:sendTo(self.player_id, Header.Motd, Settings.motd)
end

return MotdPacket