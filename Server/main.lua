package.path = package.path..';./?/init.lua'

local math = require 'math'
math.randomseed(os.time())

local utils = require 'lib.utils'
local json = require 'cjson'

Settings = json.decode(utils.readFile('conf.json'))
Server = require('src.server')()
Server:loop()