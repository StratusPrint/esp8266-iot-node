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
   'server/config.lua',
   'server/activate.lua',
   'io/gpio.lua',
   'io/trig.lua',
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
    ip, nm, gw  = wifi.sta.getip()
    print("Connected to wifi as:" .. wifi.sta.getip())
    dofile("server/activate.lc")(gw)
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
);
