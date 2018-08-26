local Datar = require 'lib.datar'
local Accounts = Datar:extend('Accounts')

function Accounts:init()
  Accounts.super.init(self, 'data/accounts.json')
  self:setTemplate {
    { 'name', 'string' },
    { 'password', 'string' },
    { 'email', 'string' }
  }
end

return Accounts
