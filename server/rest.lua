srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
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

    local f = file.open("http/index.html","r")
		if f ~= nil then
		    client:send(file.read())
        file.close()
		else
			client:send("<html>")
			client:send("File not Found - 404 error.<BR>")
			client:send("You have reached the end of the Internet of Things<BR>")
		end
    client:close();
    collectgarbage();

  end)
end)
