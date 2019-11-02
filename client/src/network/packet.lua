local Header = require 'src.network.headers'

return {
  [Header.Login] = require 'src.network.account.login',
  [Header.AddPlayer] = require 'src.network.account.add_player',
  [Header.RemovePlayer] = require 'src.network.account.remove_player'

  --[Header.AdminSave] = require 'src.network.admin.save',
  --[Header.AdminShutdown] = require 'src.network.admin.shutdown',

  --[Header.ServerStatus] = require 'src.network.public.server_status'
}
