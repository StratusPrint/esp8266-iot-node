-- Include rest module
local rest = dofile("server/rest.lc")

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
end)