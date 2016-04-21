-- Include rest module
local rest = dofile("server/rest.lc")
ip, nm, gw = wifi.ap.getip()
-- Create server
srv=net.createServer(net.TCP)
print("Rest Server started")

-- Start server
srv:listen(80,function(conn)
  conn:on("receive",function(conn,request)
    -- Handle requests
    rest.handle(conn, request)
  end)
  conn:on("sent",function(conn) conn:close() end)
  srv:on("connection", function(sck, c)
  -- Wait for connection before sending.
  print("connection established")
  sck:send("GET / HTTP/1.1\r\nHost: 192.168.0.66\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
end)
end)