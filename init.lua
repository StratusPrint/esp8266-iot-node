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
   'server/server.lua',
   'server/static.lua',
   'server/config.lua',
}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end

compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()

cfg = dofile("server/config.lc")

-- Set the wifi mode (default: AP)
wifi.setmode(cfg.mode)
print("Stratus Print Wifi Node")
print("ESP8266 mode is: " .. wifi.getmode())

-- Now you should see an SSID wireless router named STRATUS_PRINT_NODE_###...
--- when you scan for available WIFI networks
if (wifi.getmode() == wifi.SOFTAP) then
  wifi.ap.config(cfg.ap)
  wifi.ap.setip(cfg.ipconfig)
elseif (wifi.getmode() == wifi.STATION) then
  print(cfg.stationconfig.ssid)
  wifi.sta.config(cfg.stationconfig.ssid,cfg.stationconfig.pwd)
end
ap_mac = wifi.ap.getmac()

led1 = 3 --GPIO0
led2 = 4 --GPIO2
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.write(led1, gpio.HIGH);

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  file_offset = 0 -- global
  conn:on("receive", function(client,request)
    local buf = "";
    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
    if(method == nil)then
      _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
    end
    local _GET = {}
    if (vars ~= nil)then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        _GET[k] = v
      end
    end
    if (wifi.getmode() == wifi.SOFTAP) then
        -- Define some variables
  		local file_name = ""
  		local file_type = ""
  		local serve_file = dofile("server/static.lc")

      file_name = "http/register.html"
			file_type = "text/html"
			serve_file(client, file_name, file_type)
    end
    local _on,_off = "",""
    if(vars~=nil and (_GET.ssid and _GET.nkey)) then
      local joinCounter = 0
      local joinMaxAttempts = 6
      cfg.stationconfig.ssid = _GET.ssid        -- Name of the WiFi network you want to join
      cfg.stationconfig.pwd =  _GET.nkey                -- Password for the WiFi network
      srv:close()
      --close the server and set the module to STATION mode
      cfg.mode=wifi.STATION
      wifi.setmode(cfg.mode)
      wifi.sta.config(cfg.stationconfig.ssid,cfg.stationconfig.pwd)
      tmr.alarm(0, 3000, 1, function()
        local ip = wifi.sta.getip()
        if ip == nil and joinCounter < joinMaxAttempts then
          print('Attempt '..joinCounter..' to Connect to WiFi Access Point ...')
          for i=5,1,-1
          do
             gpio.write(led2, gpio.HIGH);
               tmr.delay(150000)
             gpio.write(led2, gpio.LOW);
               tmr.delay(150000)
             gpio.write(led2, gpio.HIGH);
             tmr.delay(150000)
             gpio.write(led2, gpio.LOW);
          end

          joinCounter = joinCounter +1
        else
          if joinCounter == joinMaxAttempts then
            print('Failed to connect to WiFi Access Point.')
          else
            gpio.write(led2, gpio.HIGH);
            print("Setting up ESP8266 for station mode…Please wait.")
            print("STRATUS PRINT NODE IP now is: " .. wifi.sta.getip())

            print("STRATUS PRINT AP IP now is: " .. wifi.ap.getip())
            dofile("server/server.lc")
          end
          tmr.stop(0)
          joinCounter = nil
          joinMaxAttempts = nil
          collectgarbage()
        end
      end)

    elseif(_GET.ssid) then
      buf = buf.."<font color=\"RED\"> Enter Network Key!</font>"
    end
    collectgarbage();
  end)
  conn:on("sent", function(client)
			if file_offset > 0 then
				fSend(client, file_name, file_type)
			else
				client:close()
				print("Connection closed")
				collectgarbage()
			end
		end)
end)
