local Header = require 'src.packet.headers'
return {
  [Header.Login] = require 'src.packet.private.login',
  [Header.AddPlayer] = require 'src.packet.private.add_player',
  [Header.RemovePlayer] = require 'src.packet.private.remove_player'
}
