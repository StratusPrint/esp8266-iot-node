-- Include rest module
tmr.wdclr()
tmr.delay(500000) -- 5 sec delay because there is no call back from activate
tmr.wdclr()
local rest = dofile("server/rest.lc")
ip, nm, gw = wifi.ap.getip()
-- Create server
srv=net.createServer(net.TCP)
print("Rest Server started")

-- Start server
srv:listen(99,function(conn)
  conn:on("receive",function(conn,request)
    -- Handle requests
    rest.handle(conn, request)
  end)
  conn:on("sent",function(conn) conn:close() end)
end)