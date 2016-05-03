return function(host, port , endpoint, data)
	print(host .. ":" .. port .. endpoint .. "\n\r")
	conn=net.createConnection(net.TCP, false)
	conn:on("receive", function(conn, pl)
		conn:close()
		end)
	conn:connect(port,host)
	conn:on("connection", function(conn, pl)
			print("connected")
			ok, json = pcall(cjson.encode, data)
			if ok then
				print(json)
  			conn:send("POST "..endpoint.." HTTP/1.1"..
									"\r\nContent-Length: "..string.len(json)..
									"\r\nConnection: keep-alive"..
									"\r\nHost: "..host..
									"\r\nAccept: */*"..
									"\r\nContent-Type: application/json\r\n\r\n"..json.."\r\n")
			else
  			conn:send("HTTP/1.1 409 Conflict"..
									"\r\nContent-Type: text/html"..
									"\r\nContent-Length: 20"..
									"\r\nConnection: close"..
									"\r\n\r\nFailed to parse json")
			end
		end)
	conn:on("sent", function(conn, pl) print("callback sent") end)
	return 0
end