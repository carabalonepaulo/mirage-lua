local ffi = require 'ffi'
local utils = require 'lib.utils'

local dll = (require('lib.arch') == 64 and 'ENetX64' or 'ENetX86')
local NULL = ffi.cast('void*', ffi.new('int', 0))

--[[ Load ENet ]]
ffi.cdef(utils.readFile('lib/enet.h'))
return ffi.load('bin/'..dll..'.dll')
