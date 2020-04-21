OS := $(shell uname)

.PHONY: bk7231u
bk7231u: 
	@echo "Build for BK7231u..."
	@export CFG_SUPPORT_BLE=1 SOC_NAME=2 && $(MAKE) -f application.mk application

.PHONY: bk7251
bk7251: 
	@echo "Build for BK7251..."
	@export CFG_SUPPORT_BLE=1 SOC_NAME=3 && $(MAKE) -f application.mk application

.PHONY: bk7231
bk7231: 
	@echo "Build for BK7231..."
	@export CFG_SUPPORT_BLE=0, SOC_NAME=1 && $(MAKE) -f application.mk application

.PHONY: ip
ip: 
	@$(MAKE) -f ip.mk 

.PHONY: ble
ble: 
	@$(MAKE) -f ble.mk 
	
.PHONY: clean
clean:
	@$(MAKE) -f application.mk clean
	
.PHONY: flash debug ramdebug setup
setup:
	@$(MAKE) -f application.mk $(MAKECMDGOALS)

flash: toolchain
	@$(MAKE) -f application.mk flashburn
	
debug: toolchain
	@$(MAKE) -f application.mk debug	

ramdebug: toolchain
	@$(MAKE) -f application.mk ramdebug	
