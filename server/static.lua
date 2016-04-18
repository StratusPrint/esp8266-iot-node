-- httpserver-static
-- Author: Nolan Foster
-- Refernced From: https://github.com/CosmicMac/ESP8266-remote/blob/master/filesend.lua
return function(client, file_name, file_type)
    print("Attempting to serve " .. file_name)
	local function get_file_size(fname)
		local file_size
		for k, v in pairs(file.list()) do
			if k == fname then
				file_size = v
				break
			end
		end
		return file_size
	end

	if not file.open(file_name, "r") then
		  print("failed to open " .. file_name)
		client:send([[
HTTP/1.1 404 Not Found
Server: StratusPrintNode
Content-Type: text/html
Content-Length: 14
Connection: close
File not found
]])
		return 0
	end

	local file_size = get_file_size(file_name);
	print("file size: " .. file_size)
	if file_offset == 0 then
		client:send([[
HTTP/1.1 200 OK
Server: Stratus Print Node
Content-Type: ]] .. file_type .. "\r\n" ..
[[Connection: keep-alive]] .. "\r\n\r\n"
)
	end

	local CHUNK_SIZE = 1024
  if file_size < CHUNK_SIZE then
    CHINK_SIZE = file_size
  end

	file.seek("set", file_offset)
	local chunk = file.read(CHUNK_SIZE)
	file.close()

	if chunk then
    print(chunk)
		client:send(chunk)
		print("sent chunk...")
	end

	file_offset = file_offset + CHUNK_SIZE
	print("file offset " .. file_offset)
	if file_offset > file_size then
		file_offset = 0
	end
end
