-- httpserver-error.lua
-- Part of nodemcu-httpserver, handles sending error pages to client.
-- Author: Marcos Kirsch

return function (client, req, args)

   local function getHeader(client, code, errorString, extraHeaders, mimeType)
      local header = "HTTP/1.0 " .. code .. " " .. errorString .. "\r\nServer: nodemcu-httpserver\r\nContent-Type: " .. mimeType .. "\r\n"
      for i, extraHeader in ipairs(extraHeaders) do
         header = header .. extraHeader .. "\r\n"
      end
      header = header .. "connection: close\r\n\r\n"
      return header
   end

   print("Error " .. args.code .. ": " .. args.errorString)
   args.headers = args.headers or {}
   client:send(getHeader(client, args.code, args.errorString, args.headers, "text/html"))
   client:send("<html><head><title>" .. args.code .. " - " .. args.errorString .. "</title></head><body><h1>" .. args.code .. " - " .. args.errorString .. "</h1></body></html>\r\n")

end
