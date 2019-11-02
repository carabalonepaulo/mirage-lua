local class = require 'lib.30log'
local Header = require 'src.packet.headers'
local Player = class 'Player'

function Player:init(index, ip, port, peer)
  self.index = index
  self.ip = ip
  self.port = port
  self.address = ip..':'..tostring(port)
  self.peer = peer
  
  self.character = nil
end

function Player:login(character)
  self.character = character
  self.character.map:addPlayer(self)
end

function Player:logout()
  if self.character then
    self.character.map:removePlayer(self)
    Server:sendToGroup(function(player)
      if player.character then
        return player.character.map == self.character.map
      else
        return false
      end
    end, Header.RemovePlayer, self.character.name)
  end
end

return Player