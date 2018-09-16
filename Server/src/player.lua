local class = require 'lib.30log'
local bit = require 'bit'
local json = require 'cjson'
local Header = require 'src.packet.headers'
local Player = class 'Player'

function Player:init(index, peer)
  self.index = index
  self.peer = peer
  self.account = nil

  self:loadAddress()
end

function Player:isLoggedIn()
  return self.account ~= nil
end

function Player:loadAddress()
  local address = self.peer.address
  self.ip = string.format('%d.%d.%d.%d',
    bit.band(address.host, 0xFF),
    bit.band(bit.rshift(address.host, 8), 0xFF),
    bit.band(bit.rshift(address.host, 16), 0xFF),
    bit.band(bit.rshift(address.host, 24), 0xFF))
  self.port = address.port
  self.address = self.ip..':'..tostring(self.port)
end

function Player:loadCharacters()
  self.characters = {}
  for i = 1, Settings.max_chars do
    local char = Server.database:loadCharacter(self.account.id, i)
    if char then
      table.insert(self.characters, char)
    end
  end
end

function Player:createChar()
  error('not implemente yet')
end

function Player:deleteChar(char_index)
  Server.database:deleteCharacter(self.account.id, char_index)
end

function Player:isAdmin()
  return self.account.rank == 'admin'
end

function Player:login(account)
  self.account = account
  self:loadCharacters()
  self:sendCharactersInfo()
end

-- Envia somente as informações que serão exibidas na seleção de personagem.
-- Tal como: nome, nível e classe por exemplo.
function Player:sendCharactersInfo()
  local chars = self.characters
  local info = {}
  for i = 1, #chars do
    table.insert(info, {
      chars[i].index,
      chars[i].sprite_name,
      chars[i].name,
      chars[i].level
    })
  end
  Server:sendTo(self.index, Header.CharactersInfo, info)
end

return Player
