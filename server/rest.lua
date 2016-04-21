-- Module declaration
local REST = {}

function REST.handle(conn, request)

-- Variables
local pin
local direction
local value
local answer = {}
local gpio_type
local variables = {}

local get_gpio = dofile("io/gpio.lc")

-- Variables
variables["temperature"] = 30

-- Find start
local e = string.find(request, "/")
local request_handle = string.sub(request, e + 1)

-- Cut end
e = string.find(request_handle, "HTTP")
request_handle = string.sub(request_handle, 0, (e-2))

-- Find gpio
e = string.find(request_handle, "/")
if e == nil then
  gpio_type = request_handle
else
  gpio_type = string.sub(request_handle, 0, (e-1))

  -- Find pin & direction
  request_handle = string.sub(request_handle, (e+1))
  e = string.find(request_handle, "/")


  if e == nil then
    pin = request_handle
    pin = tonumber(pin)
  else
    pin = string.sub(request_handle, 0, (e-1))
    pin = tonumber(pin)
    request_handle = string.sub(request_handle, (e+1))
    direction = request_handle
  end
end


-- Apply direction
if pin == nil then
  for key,value in pairs(variables) do
     if key == gpio then answer[key] = value end
  end
end


if gpio_type == "gpio" then
  -- Debug output
  print('GPIO: ', gpio_type)
  print('Pin: ', pin)
  print('Type: ', direction)

  if direction == "o" then
    gpio.mode(pin, gpio.OUTPUT)
	  answer['id'] = node.chipid()
    answer['message'] = "Pin D" .. pin .. " set to output"
  elseif direction == "i" then
    gpio.mode(pin, gpio.INPUT)
		answer['id'] = node.chipid()
    answer['message'] = "Pin D" .. pin .. " set to input"
  elseif direction == "p" then
    pwm.setup(pin, 100, 0)
    pwm.start(pin)
    answer['message'] = "Pin D" .. pin .. " set to PWM"
	elseif direction == nil then
	  data = get_gpio(pin,direction)
		answer['id'] = node.chipid()
	  answer['data'] = data.value
  elseif direction == "dht" then
    data = get_gpio(pin,direction)
    answer['id'] = node.chipid()
		answer['temp'] = string.format("%d.%03d",data.temp,data.temp_dec)
    answer['humi'] = string.format("%d.%03d",data.humi,data.humi_dec)
  end
end


if gpio_type == "adc" then
  if direction == nil then
    value = adc.read(pin)
		answer['id'] = node.chipid()
    answer['data'] = value
  else
    pwm.setduty(pin, direction)
		answer['id'] = node.chipid()
    answer['message'] = "Pin D" .. pin .. " set to " .. direction
  end
end

conn:send("HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nConnection: close\r\n\r\n" .. table_to_json(answer) .. "\r\n")

end

function table_to_json(json_table)

ok, json = pcall(cjson.encode, json_table)
if ok then
  return json
else
  return '{error:failed to encode}'
end
end

return REST
