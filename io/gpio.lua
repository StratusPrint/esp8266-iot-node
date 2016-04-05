return function(gpio, type)
  data = {}
  if type = "dht" then
    data.status, data.temp, data.humi, data.temp_dec, data.humi_dec = dht.read(gpio)
    if status == dht.OK then
      --Since we are using integer firmware we need to concatinate the values
          data.temp = math.floor(data.temp)
          data.humi = math.floor(data.humi)
        print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
              data.temp,
              data.temp_dec,
              data.humi,
              data.humi_dec
        ))
    elseif status == dht.ERROR_CHECKSUM then
        data.status = "DHT Checksum error."
    elseif status == dht.ERROR_TIMEOUT then
        data.status = "DHT timed out." )
    end
    return data
  end
end
