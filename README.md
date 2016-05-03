# Esp8266 IoT Node

# Usage
Update paths and baud rate in the make script to fit your system
```
make
```
	@echo "make upload_all           to upload all"
	@echo "make upload_http          to upload http files"
	@echo "make upload_server        to upload server files"
	@echo "make upload_init          to upload init file"
	@echo "make list                 to list all files"
	@echo "make format               format filesystem"
	@echo "make flash                reflash newest firmware"
	@echo "make tty                  check if chip is connected to "$(PORT)
	@echo "make baud                 check baud rate of port "$(PORT)
#API Documantation
##General JSON Response
{
  "id": [chip id],
  "data": [value]
}
##GPIO
gpio is to write or read on digital pins of the ESP8266. For example:<BR>
```
/gpio/[int:pin #]/[int:state||string:type]
```
###Examples
    /gpio/1/high    sets pin number 1 to a high
    /gpio/1/low     sets pin number 1 to a low
    /gpio/1/input   reads pin number 1 as an input
    /gpio/1/pon     sets pin number 1 to a pwm [1][512]
    
##DHT
```
    /gpio/1/dht  reads dht sensor from pin number 1
```
####DHT JSON RESPONSE

{
  "id": [chip id],
  "temp": [float:value],
  "humi": [float:value]
}

This will send data to an endpoint when triggered
```
  /gpio/[int:pin #]/trig
```
####Trigger JSON RESPONSE

{
  "id": [chip id],
  "data": "trigger set"
}

##ADC
ADC is to write or read on anolog pin of the ESP8266. For example:<BR>
/adc/[char:r||w]
###Examples
    /adc/r      reads value from adc
    /adc/w   writes value to adc

##Connect
Connect is to connect the node to a network<BR>
/connect?ssid=[ssid]&nkey=[networkkey]

#Calling API in Python
```
from urllib2 import Request, urlopen
from json import dumps

def get_temp(node_ip, gpio):

    req = Request(node_ip+"/"+gpio+"/dht")
    response_body = urlopen(req).read()
    data = json.loads(response_body)
    temp = data['data']['temp']
    humidity = data['data']['humi']
    print("temp: "+temp+" hunidity: "+ humi)

    return data
```
