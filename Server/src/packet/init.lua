local Header = require 'src.packet.headers'

return {
  [Header.Login] = require 'src.packet.account.login',
  [Header.AddPlayer] = require 'src.packet.account.add_player',
  [Header.RemovePlayer] = require 'src.packet.account.remove_player'
}
