local List = require 'lib.list'
local json = require 'cjson'
local utils = require 'lib.utils'
local hash32 = require('xxhash').hash32
local fs = require 'fs'
local Database = require('src.database'):extend('JsonDatabase')

local ACCOUNTS_PATH = 'data/accounts.json'
local CHARACTERS_PATH = 'data/characters/%i-%i.json'

function Database:init()

end

function Database:loadAccounts()
  local account_data = json.decode(utils.readFile(ACCOUNTS_PATH))
  return List(account_data)
end

function Database:saveAccounts(accounts)
  utils.writeFile(ACCOUNTS_PATH, json.encode(accounts))
end

-- carrega os personagens de uma determinada conta
function Database:loadCharacter(account_id, character_id)
  local file_path = string.format(CHARACTERS_PATH, account_id, character_id)
  if fs.is(file_path) then
    return json.decode(utils.readFile(file_path))
  end
  return nil
end

-- salva os dados de um dos personagens da conta
function Database:saveCharacter(account_id, character_id)
end

function Database:deleteCharacter(account_id, character_id)
  os.remove(string.format(CHARACTERS_PATH, account_id, character_id))
end

return Database
