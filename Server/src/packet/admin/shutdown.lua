local Packet = require 'src.packet.packet'
local ShutdownPacket = Packet:extend 'ShutdownPacket'

function ShutdownPacket:handle(data)
  if not self.server.players[self.player_id]:isAdmin() then
    self.server:ban(self.players[self.player_id].account.name)
    self.server:forceDisconnect(self.player_id)
    return
  end
  self.server:shutdown()
end

return ShutdownPacket