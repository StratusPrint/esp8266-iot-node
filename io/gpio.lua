-- gpio
-- Author: Nolan Foster
-- ESP8266-12 pinout
-- GPIO0 = 3
-- GPIO1 = 10
-- GPIO2 = 4
-- GPIO3 = 9
-- GPIO4 = 2
-- GPIO5 = 1
-- GPIO12 = 6
-- GPIO13 = 7
-- GPIO14 = 5
-- GPIO15 = 8

return function(gpio, type)
  data = {}
  if type == "dht" then
    data.status, data.temp, data.humi, data.temp_dec, data.humi_dec = dht.read(gpio)

    if data.status == dht.OK then
      --Since we are using integer firmware we need to concatinate the values
          data.status = "OK"
          data.temp = math.floor(data.temp)
          data.humi = math.floor(data.humi)
        print(string.format("temp:%d.%03d;humi:%d.%03d\r\n",
              data.temp,
              data.temp_dec,
              data.humi,
              data.humi_dec
        ))
    elseif status == dht.ERROR_CHECKSUM then
        data.status = "DHT Checksum error."
    elseif status == dht.ERROR_TIMEOUT then
        data.status = "DHT timed out."
    end
    return data
  elseif type == "trig" then
    gpio.mode(pin, gpio.INPUT)
    --gpio.trig(pin, function)
  elseif type == nil then
    data.value = gpio.read(gpio)
    return data
  end

end
