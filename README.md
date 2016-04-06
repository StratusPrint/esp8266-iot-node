# Esp8266 IoT Node
Internet of thing node based on nodemcu.


# Usage
run make

#API Documantation
##GPIO
gpio is to write or read on digital pins of the ESP8266. For example:<BR>
/gpio/[int:pin #]/[int:state||string:type]
###Examples
    /gpio/1/0    sets pin number 1 to a low state
    /gpio/1/1    sets pin number 1 to a high state
    /gpio/1      reads value from pin number 1 in JSON format
    /gpio/1/dht  reads dht sensor from pin number 1 

##ADC
ADC is to write or read on anolog pin of the ESP8266. For example:<BR>
/adc/[char:r||w]
###Examples
    /adc/r      reads value from adc
    /adc/w   writes value to adc

##Connect
Connect is to connect the node to a network<BR>
/connect?ssid=[ssid]&nkey=[networkkey]
