######################################################################
# User configuration
######################################################################
# Path to nodemcu-uploader (https://github.com/kmpm/nodemcu-uploader)
NODEMCU-UPLOADER=nodemcu-uploader/nodemcu-uploader.py
# Serial port
PORT=/dev/ttyUSB0
SPEED=115200

######################################################################
# End of user config
######################################################################
LUA_FILES := \
   init.lua \

# Print usage
usage:
	@echo "make upload_all           to upload all"
	@echo $(TEST)

# Upload all
upload_all: $(LUA_FILES) $(HTTP_FILES)
	@python $(NODEMCU-UPLOADER) -b $(SPEED) -p $(PORT) upload $(foreach f, $^, $(f)) --restart
