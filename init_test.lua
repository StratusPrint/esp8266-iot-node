-- Compile server code and remove original .lua files.
-- This only happens the first time afer the .lua files are uploaded.

local compileAndRemoveIfNeeded = function(f)
   if file.open(f) then
      file.close()
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
   end
end

local serverFiles = {
   'server/rest.lua',
   'server/server.lua',
   'server/static.lua',
   'server/config.lua',
   'server/request.lua',
   'server/activate.lua',
   'io/gpio.lua',
}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end

compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()

-- Set the wifi mode (default: AP)
wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="SP_NODE_"..node.chipid(),auth=wifi.AUTH_OPEN})

enduser_setup.start(
  function()
    print("Connected to wifi as:" .. wifi.sta.getip())
    dofile("server/server.lc")
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
);
