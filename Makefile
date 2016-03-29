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
PORT=ttyUSB0
SPEED=115200
RELEASES= curl -s https://api.github.com/repos/nodemcu/nodemcu-firmware/releases/latest | jq -r '.assets[] | select(.name) | .browser_download_url'
######################################################################
# End of user config
######################################################################
HTTP_FILES := $(wildcard http/*)
SERVER_FILES := $(wildcard server/*)
INIT := \
   init.lua \

# Print usage
usage:
	@echo "make upload_all           to upload all"
	@echo "make list                 to list all files"
	@echo "make nuke                 format filesystem"
	@echo "make flash                reflash newest firmware"
	@echo "make upload_http          to upload http files"
	@echo "make tty                  check if chip is connected to "$(PORT)
	@echo "make baud                 check baud rate of port "$(PORT)

# Upload all
upload_all: $(INIT) $(SERVER_FILES) $(HTTP_FILES)
	@python $(NODEMCU-UPLOADER) -b $(SPEED) -p /dev/$(PORT) upload $(foreach f, $^, $(f)) --restart

# Upload http
upload_http: $(HTTP_FILES)
	@python $(NODEMCU-UPLOADER) -b $(SPEED) -p /dev/$(PORT) upload $(foreach f, $^, $(f)) --restart

#list files on chip
list:
	@python $(NODEMCU-UPLOADER) -p /dev/$(PORT) file list

#reformat the filesystem
nuke:
	@python $(NODEMCU-UPLOADER) -b $(SPEED) -p /dev/$(PORT) file format --restart

#flash the firmware
flash:
	@python $(ESP-TOOL) --port /dev/$(PORT) write_flash 0x00000 $(FIRMWARE)

#test connection
tty:
	dmesg | grep $(PORT)

baud:
	stty -F /dev/$(PORT)
