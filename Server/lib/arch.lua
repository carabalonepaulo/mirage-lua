-- Determine your OS bitness
-- https://stackoverflow.com/a/48094597
local ffi = require 'ffi'
local arch
if ffi.os == 'Windows' then
   arch = os.getenv('PROCESSOR_ARCHITECTURE')
else
   arch = io.popen('uname -m'):read('*a')
end
return (arch or ''):match('64') and 64 or 32
