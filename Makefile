######################################################################
# User configuration
######################################################################
# Path to nodemcu-uploader (https://github.com/kmpm/nodemcu-uploader)
NODEMCU-UPLOADER=nodemcu-uploader/nodemcu-uploader.py
# Path to esptool
ESP-TOOL=esptool/esptool.py
#path to firmware
FIRMWARE=bin/nodemcu_integer_*
# Serial port
PORT=/dev/ttyUSB0
SPEED=115200
RELEASES= curl -s https://api.github.com/repos/nodemcu/nodemcu-firmware/releases/latest | jq -r '.assets[] | select(.name) | .browser_download_url'
######################################################################
# End of user config
######################################################################
HTTP_FILES := $(wildcard http/*)
LUA_FILES := \
   init.lua \
	 httpserver.lua\
	 httpserver-request.lua\
	 httpserver-static.lua\

# Print usage
usage:
	@echo "make upload_all           to upload all"
	@echo "make list                 to list all files"
	@echo "make nuke                 format filesystem"
	@echo "make flash                reflash newest firmware"
	@echo "make upload_http          to upload http files"
	@echo $(TEST)

# Upload all
upload_all: $(LUA_FILES) $(HTTP_FILES)
	@python $(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) upload $(foreach f, $^, $(f)) --restart

# Upload http
upload_http: $(HTTP_FILES)
	@python $(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) upload $(foreach f, $^, $(f)) --restart

#list files on chip
list:
	@python $(NODEMCU-UPLOADER) -p $(PORT) file list

#reformat the filesystem
nuke:
	@python $(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) file format

#flash the firmware
flash:
	python $(ESP-TOOL) --port $(PORT) write_flash 0x00000 $(FIRMWARE)
