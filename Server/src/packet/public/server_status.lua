local Header = require 'src.packet.headers'

return function(server, player, data)
  server:sendTo(player.index, Header.ServerStatus, '>.<')
end