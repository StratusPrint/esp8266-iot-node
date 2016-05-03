return function(host)
	print(host)
	conn=net.createConnection(net.TCP, false)
	conn:on("receive", function(conn, pl)
		conn:close()
    dofile("server/server.lc")
		end)
	conn:connect(5000,host)
	conn:on("connection", function(conn, pl)
			print("connected")
			conn:send("GET ".."/nodes/activate?".."ip="..wifi.sta.getip()
								.."&id="..node.chipid()
								.." HTTP/1.1\r\nHost: ".. host
								.."// \r\n Connection: keep-alive\r\nAccept: */*\r\n\r\n")
		end)
	conn:on("sent", function(conn, pl) print("activate request sent") end)
	return 0
end