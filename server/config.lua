-- httpserver-config
-- Author: Nolan Foster
cfg={}
cfg.debug = true

cfg.mode = wifi.SOFTAP -- both station and access point

cfg.ap={}
cfg.ap.ssid="SP_NODE_"..node.chipid()

cfg.ap.pwd="alfanetwork"

cfg.ipconfig = {}
cfg.ipconfig.ip = "192.168.1.1"
cfg.ipconfig.netmask = "255.255.255.0"
cfg.ipconfig.gateway = "192.168.1.1"

cfg.stationconfig = {}
cfg.stationconfig.ssid = "Internet"   -- SSID of the default wifi network you want to join
cfg.stationconfig.pwd =  "password"   -- network key for the wifi network

return cfg
