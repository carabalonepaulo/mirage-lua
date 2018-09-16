local Header = require 'src.packet.headers'

return {
  [Header.Login] = require 'src.packet.account.login',
  [Header.Register] = require 'src.packet.account.register',
  [Header.Motd] = require 'src.packet.public.motd',

  [Header.ASave] = require 'src.packet.admin.save',
  [Header.AShutdown] = require 'src.packet.admin.shutdown'
}
