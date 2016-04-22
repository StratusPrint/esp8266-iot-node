return function(host, port , endpoint, data)
	print(host)
	conn=net.createConnection(net.TCP, false)
	conn:on("receive", function(conn, pl)
		conn:close()
    dofile("server/server.lc")
		end)
	conn:connect(port,host)
	conn:on("connection", function(conn, pl)
			print("connected")
			ok, json = pcall(cjson.encode, data)
			if ok then
  			conn:send("POST ".. endpoint
									.." HTTP/1.1\r\nHost: ".. host
									.."// \r\n Connection: keep-alive\r\nAccept: */*\r\n\r\n"
									.. json)
			else
  			conn:send("POST ".. endpoint
									.." HTTP/1.1\r\nHost: ".. host
									.."// \r\n Connection: keep-alive\r\nAccept: */*\r\n\r\n"
									.. "{'message': error}")
			end
		end)
	conn:on("sent", function(conn, pl) print("activate request sent") end)
	return 0
end