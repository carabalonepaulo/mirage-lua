--[[return {
  Login = 1,
  Register = 2,
  Motd = 3,
  CharactersInfo = 4,
  CreateChar = 5,
  DeleteChar = 6,

  ASave = 150,
  AShutdown = 151
}]]

local enum = require('lib.enum').enum
return enum [[
  Login,
  Register,
  Motd,
  CharactersInfo,
  CreateChar,
  DeleteChar,
  
  ASave,
  AShutdown
]]