local Header = require 'src.packet.headers'
return {
  [Header.Login] = require 'src.packet.handler.login',
}
