-- port 5000
-- max 32 peers
local Server = require('src.server')()
while true do
  Server:update()
end
Server:close()
