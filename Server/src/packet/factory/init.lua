local Header = require 'src.packet.headers'
return {
  [Header.Login] = require 'src.packet.factory.login',
  [Header.AddPlayer] = require 'src.packet.factory.add_player',
  [Header.RemovePlayer] = require 'src.packet.factory.remove_player'
}
