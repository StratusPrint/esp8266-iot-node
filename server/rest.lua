-- Module declaration
local REST = {}

function REST.handle(conn, request)
print(request)
-- Variables
local pin
local direction
local value
local answer = {}
local gpio_type
local variables = {}

local get_gpio = dofile("io/gpio.lc")

--trigger call back
function debounce (func,pin)
    local last = 0
    local delay = 200000

    return function (...)
        local now = tmr.now()
        if now - last < delay then return end

        last = now
        return func(pin)
    end
end

function onChange(pin)
    if gpio.read(pin) == 0 then
        ip, nm, gw = wifi.sta.getip()
        answer['data'] = "success"
        dofile("io/trig.lc")(gw, 5000 , "/nodes/trigger/callback", answer)
        tmr.delay(500000)
    end
end
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

  if direction == "high" then
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.HIGH)
	  answer['id'] = node.chipid()
    answer['data'] = "success"
  elseif direction == "low" then
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.LOW)
	  answer['id'] = node.chipid()
    answer['data'] = "success"
  elseif direction == "pon" then
    pwm.setup(pin, 1, 512)
    pwm.start(pin)
    answer['data'] = "success"
  elseif direction == "poff" then
    pwm.stop(pin)
    answer['data'] = "success"
  elseif direction == "dht" then
    data = get_gpio(pin,direction)
    answer['id'] = node.chipid()
		answer['temp'] = string.format("%d.%03d",data.temp,data.temp_dec)
    answer['humi'] = string.format("%d.%03d",data.humi,data.humi_dec)
	elseif direction == "input" then
    gpio.mode(pin, gpio.INPUT)
    print("Getting Data")
	  value = gpio.read(pin)
		answer['id'] = node.chipid()
	  answer['data'] = value
	elseif direction == "trig" then
    gpio.mode(pin,gpio.INT,gpio.PULLUP)
    gpio.trig(pin,"down", debounce(onChange,pin))
		answer['id'] = node.chipid()
	  answer['data'] = "trigger set"
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
    answer['message'] = "success"
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
