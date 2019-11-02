local Header = require 'src.network.headers'
return {
  [Header.Login] = require 'src.network.private.login',
  [Header.AddPlayer] = require 'src.network.private.add_player',
  [Header.RemovePlayer] = require 'src.network.private.remove_player'
}
