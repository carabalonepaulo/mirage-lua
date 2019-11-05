local class = require 'lib.30log'
local Header = require 'src.packet.headers'
local PacketFactory = require 'src.packet.factory'
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

    local players = self.character.map.players
    local high_index = Server:getHighIndex()

    for i = 1, high_index do
      if players[i] then
        Server:sendTo(players[i].index, Header.RemovePlayer,
          PacketFactory[Header.removePlayer](self.index))
      end
    end
  end
end

return Player