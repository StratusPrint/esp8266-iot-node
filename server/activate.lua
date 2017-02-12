return function(host)
	conn=net.createConnection(net.TCP, 0)
	conn:on("receive", function(conn, pl)
		conn:close()
		end)
	conn:connect(7112,host)
	conn:on("disconnection", function(conn, pl)
		print("Activation failed")
		dofile("server/server.lc")
		end)
	conn:on("connection", function(conn, pl)
			print("connected")
			conn:send("GET ".."/nodes/activate?".."ip="..wifi.sta.getip()
								.."&port="..99
								.."&id="..node.chipid()
								.." HTTP/1.1\r\nHost: ".. host
								.."// \r\n Connection: keep-alive\r\nAccept: */*\r\n\r\n")
		end)
	conn:on("sent", function(conn, pl) print("activate request sent")
		dofile("server/server.lc")
		end)
	return 0
end