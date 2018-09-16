local Header = require 'src.packet.headers'

return function(self, player_index)
  self:sendTo(player_index, Header.Motd, Settings.motd)
end
