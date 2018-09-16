package.path = package.path..';./?/init.lua'

local utils = require 'lib.utils'
local json = require 'cjson'

Settings = json.decode(utils.readFile('data/settings.json'))

Server = require('src.server')()
Server:loop()
