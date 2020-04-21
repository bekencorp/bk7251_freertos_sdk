# Add path of toolchain to system path first, or enable ARM_GCC_TOOLCHAIN 
# -------------------------------------------------------------------
#ARM_GCC_TOOLCHAIN = toolchain/gcc-arm-none-eabi-4_9-2015q1/bin/

CROSS_COMPILE = $(ARM_GCC_TOOLCHAIN)arm-none-eabi-

# Compilation tools
AR = $(CROSS_COMPILE)ar
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
NM = $(CROSS_COMPILE)nm
LD = $(CROSS_COMPILE)gcc
GDB = $(CROSS_COMPILE)gdb
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

Q := @
ifeq ($(V),1)
Q := 
endif
OS := $(shell uname)

ENCRYPT_ARGS = 
ifeq ($(findstring MINGW32_NT, $(OS)), MINGW32_NT) 
ENCRYPT = "./tool/crc binary/encrypt.exe"
else ifeq ($(findstring CYGWIN, $(OS)), CYGWIN) 
ENCRYPT = "./tool/crc binary/encrypt.exe"
else ifeq ($(findstring Darwin, $(OS)), Darwin) 
ENCRYPT = "./tool/crc binary/encrypt.darwin"
ENCRYPT_ARGS = 0 0 0
else
ENCRYPT = "./tool/crc binary/encrypt"
ENCRYPT_ARGS = 0 0 0
endif

# -------------------------------------------------------------------
# Initialize target name and target object files
# -------------------------------------------------------------------

all: application 

TARGET=debug

OBJ_DIR=$(TARGET)
BIN_DIR=$(TARGET)

# -------------------------------------------------------------------
# Include folder list
# -------------------------------------------------------------------
INCLUDES =

INCLUDES += -I./config
INCLUDES += -I./beken378/common
INCLUDES += -I./beken378/demo
INCLUDES += -I./beken378/app
INCLUDES += -I./beken378/app/config
INCLUDES += -I./beken378/app/ftp
INCLUDES += -I./beken378/app/http
INCLUDES += -I./beken378/app/standalone-station
INCLUDES += -I./beken378/app/standalone-ap
INCLUDES += -I./beken378/app/tftp
INCLUDES += -I./beken378/ip/common
INCLUDES += -I./beken378/ip/ke/
INCLUDES += -I./beken378/ip/mac/
INCLUDES += -I./beken378/ip/lmac/src/hal
INCLUDES += -I./beken378/ip/lmac/src/mm
INCLUDES += -I./beken378/ip/lmac/src/ps
INCLUDES += -I./beken378/ip/lmac/src/rd
INCLUDES += -I./beken378/ip/lmac/src/rwnx
INCLUDES += -I./beken378/ip/lmac/src/rx
INCLUDES += -I./beken378/ip/lmac/src/scan
INCLUDES += -I./beken378/ip/lmac/src/sta
INCLUDES += -I./beken378/ip/lmac/src/tx
INCLUDES += -I./beken378/ip/lmac/src/vif
INCLUDES += -I./beken378/ip/lmac/src/rx/rxl
INCLUDES += -I./beken378/ip/lmac/src/tx/txl
INCLUDES += -I./beken378/ip/lmac/src/p2p
INCLUDES += -I./beken378/ip/lmac/src/chan
INCLUDES += -I./beken378/ip/lmac/src/td
INCLUDES += -I./beken378/ip/lmac/src/tpc
INCLUDES += -I./beken378/ip/lmac/src/tdls
INCLUDES += -I./beken378/ip/umac/src/mesh
INCLUDES += -I./beken378/ip/umac/src/mfp
INCLUDES += -I./beken378/ip/umac/src/rc
INCLUDES += -I./beken378/ip/umac/src/apm
INCLUDES += -I./beken378/ip/umac/src/bam
INCLUDES += -I./beken378/ip/umac/src/llc
INCLUDES += -I./beken378/ip/umac/src/me
INCLUDES += -I./beken378/ip/umac/src/rxu
INCLUDES += -I./beken378/ip/umac/src/scanu
INCLUDES += -I./beken378/ip/umac/src/sm
INCLUDES += -I./beken378/ip/umac/src/txu
INCLUDES += -I./beken378/driver/include
INCLUDES += -I./beken378/driver/common/reg
INCLUDES += -I./beken378/driver/entry
INCLUDES += -I./beken378/driver/dma
INCLUDES += -I./beken378/driver/intc
INCLUDES += -I./beken378/driver/phy
INCLUDES += -I./beken378/driver/rc_beken
INCLUDES += -I./beken378/driver/flash
INCLUDES += -I./beken378/driver/rw_pub
INCLUDES += -I./beken378/driver/common/reg
INCLUDES += -I./beken378/driver/common
INCLUDES += -I./beken378/driver/uart
INCLUDES += -I./beken378/driver/sys_ctrl
INCLUDES += -I./beken378/driver/gpio
INCLUDES += -I./beken378/driver/general_dma
INCLUDES += -I./beken378/driver/spidma
INCLUDES += -I./beken378/driver/icu
INCLUDES += -I./beken378/func/include
INCLUDES += -I./beken378/func/rf_test
INCLUDES += -I./beken378/func/user_driver
INCLUDES += -I./beken378/func/power_save
INCLUDES += -I./beken378/func/uart_debug
INCLUDES += -I./beken378/func/ethernet_intf
INCLUDES += -I./beken378/func/hostapd-2.5/hostapd
INCLUDES += -I./beken378/func/hostapd-2.5/bk_patch
INCLUDES += -I./beken378/func/hostapd-2.5/src/utils
INCLUDES += -I./beken378/func/hostapd-2.5/src/ap
INCLUDES += -I./beken378/func/hostapd-2.5/src/common
INCLUDES += -I./beken378/func/hostapd-2.5/src/drivers
INCLUDES += -I./beken378/func/hostapd-2.5/src
INCLUDES += -I./beken378/func/lwip_intf/lwip-2.0.2/src
INCLUDES += -I./beken378/func/lwip_intf/lwip-2.0.2/port
INCLUDES += -I./beken378/func/lwip_intf/lwip-2.0.2/src/include
INCLUDES += -I./beken378/func/lwip_intf/lwip-2.0.2/src/include/netif
INCLUDES += -I./beken378/func/lwip_intf/lwip-2.0.2/src/include/lwip
INCLUDES += -I./beken378/func/temp_detect
INCLUDES += -I./beken378/func/spidma_intf
INCLUDES += -I./beken378/func/saradc_intf
INCLUDES += -I./beken378/func/rwnx_intf
INCLUDES += -I./beken378/func/joint_up
INCLUDES += -I./beken378/func/base64
INCLUDES += -I./beken378/func/easy_flash
INCLUDES += -I./beken378/func/easy_flash/inc
INCLUDES += -I./beken378/func/easy_flash/port
INCLUDES += -I./beken378/os/include
INCLUDES += -I./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/portable/Keil/ARM968es
INCLUDES += -I./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/include
INCLUDES += -I./beken378/os/FreeRTOSv9.0.0

# For WPA3
# INCLUDES += -I./beken378/func/wolfssl


#paho-mqtt
INCLUDES += -I./beken378/func/paho-mqtt/client
INCLUDES += -I./beken378/func/paho-mqtt/client/src
INCLUDES += -I./beken378/func/paho-mqtt/packet/src

INCLUDES += -I./beken378/driver/ble
INCLUDES += -I./beken378/driver/ble/ble_pub/ip/ble/hl/inc
INCLUDES += -I./beken378/driver/ble/ble_pub/ip/ble/profiles/comm/api
INCLUDES += -I./beken378/driver/ble/ble_pub/ip/ble/profiles/sdp/api
INCLUDES += -I./beken378/driver/ble/ble_pub/modules/app/api
INCLUDES += -I./beken378/driver/ble/ble_pub/modules/ecc_p256/api
INCLUDES += -I./beken378/driver/ble/ble_pub/modules/common/api
INCLUDES += -I./beken378/driver/ble/ble_pub/modules/dbg/api
INCLUDES += -I./beken378/driver/ble/ble_pub/modules/rwip/api
INCLUDES += -I./beken378/driver/ble/ble_pub/modules/rf/api
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/arch
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/arch/boot
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/arch/compiler
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/arch/ll
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/build/ble_full/reg/fw
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/driver/reg
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/driver/uart
INCLUDES += -I./beken378/driver/ble/ble_pub/plf/refip/src/driver/ble_icu

INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ahi/api
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/api
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/inc
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gap/gapc
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gap/gapm
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gap/smpc
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gap/smpm
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gap
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gatt/attc
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gatt/attm
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gatt/atts
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gatt
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gatt/gattc
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/gatt/gattm
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/l2c/l2cc
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/hl/src/l2c/l2cm
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/ll/src/em
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/ll/src/llc
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/ll/src/lld
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/ll/src/llm
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ble/ll/src/rwble
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/ea/api
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/em/api
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/hci/api
INCLUDES += -I./beken378/driver/ble/ble_lib/ip/hci/src
INCLUDES += -I./beken378/driver/ble/ble_lib/modules/h4tl/api
INCLUDES += -I./beken378/driver/ble/ble_lib/modules/ke/api
INCLUDES += -I./beken378/driver/ble/ble_lib/modules/ke/src
INCLUDES += -I./beken378/driver/ble/ble_pub/modules/ecc_p256/api

#demo module
INCLUDES += -I./demos
INCLUDES += -I./demos/application/ap_sta
INCLUDES += -I./demos/application/light/common
INCLUDES += -I./demos/application/light/light_client
INCLUDES += -I./demos/application/light/light_server
INCLUDES += -I./demos/application/param_manage
INCLUDES += -I./demos/common/base64
INCLUDES += -I./demos/common/json
INCLUDES += -I./demos/helloworld
INCLUDES += -I./demos/net/iperf
INCLUDES += -I./demos/net/mqtt
INCLUDES += -I./demos/net/mqtt
INCLUDES += -I./demos/net/tcp_client
INCLUDES += -I./demos/net/tcp_server
INCLUDES += -I./demos/net/uart1_tcp_server
INCLUDES += -I./demos/net/udp
INCLUDES += -I./demos/os/os_mutex
INCLUDES += -I./demos/os/os_queue
INCLUDES += -I./demos/os/os_sem
INCLUDES += -I./demos/os/os_thread
INCLUDES += -I./demos/os/os_timer
INCLUDES += -I./demos/peripheral
INCLUDES += -I./demos/peripheral/flash
INCLUDES += -I./demos/peripheral/gpio
INCLUDES += -I./demos/peripheral/pwm
INCLUDES += -I./demos/wifi/airkiss_station
INCLUDES += -I./demos/wifi/scan
INCLUDES += -I./demos/wifi/softap
INCLUDES += -I./demos/wifi/station
INCLUDES += -I./demos/wifi/station_power_save

# -------------------------------------------------------------------
# Source file list
# -------------------------------------------------------------------
SRC_C =
DRAM_C =
SRC_OS =

#application layer
SRC_C += ./beken378/app/app.c
SRC_C += ./beken378/app/ate_app.c
SRC_C += ./beken378/app/config/param_config.c
SRC_C += ./beken378/app/standalone-ap/sa_ap.c
SRC_C += ./beken378/app/standalone-station/sa_station.c
SRC_C += ./beken378/app/ftp/ftpd.c
SRC_C += ./beken378/app/ftp/vfs.c
SRC_C += ./beken378/app/http/lite-log.c
SRC_C += ./beken378/app/http/utils_httpc.c
SRC_C += ./beken378/app/http/utils_net.c
SRC_C += ./beken378/app/http/utils_timer.c
SRC_C += ./beken378/app/tftp/tftpclient.c

#demo module
SRC_C += ./beken378/demo/ieee802_11_demo.c
SRC_C += ./demos/application/ap_sta/ap_sta_demo.c
SRC_C += ./demos/application/light/common/light_commond.c
SRC_C += ./demos/application/light/common/light_commun_protocol.c
SRC_C += ./demos/application/light/light_client/light_client_app_demo.c
SRC_C += ./demos/application/light/light_client/light_client_sockt.c
SRC_C += ./demos/application/light/light_server/light_server_app.c
SRC_C += ./demos/application/light/light_server/light_socket.c
SRC_C += ./demos/application/param_manage/param_manage.c
SRC_C += ./demos/common/base64/base64_enc.c
SRC_C += ./demos/common/base64/base64_enc.c
SRC_C += ./demos/common/json/cJSON.c
SRC_C += ./demos/common/json/cJsontest.c
SRC_C += ./demos/helloworld/helloworld.c
SRC_C += ./demos/net/iperf/iperf.c
SRC_C += ./demos/net/mqtt/mqtt_echo.c
SRC_C += ./demos/net/mqtt/mqtt_test.c
SRC_C += ./demos/net/tcp_client/tcp_client_demo.c
SRC_C += ./demos/net/tcp_server/tcp_server_demo.c
SRC_C += ./demos/net/uart1_tcp_server/uart1_tcp_server_demo.c
SRC_C += ./demos/net/udp/udp_client_demo.c
SRC_C += ./demos/net/udp/udp_server_demo.c
SRC_C += ./demos/os/os_mutex/os_mutex.c
SRC_C += ./demos/os/os_queue/os_queue.c
SRC_C += ./demos/os/os_sem/os_sem.c
SRC_C += ./demos/os/os_thread/os_thread.c
SRC_C += ./demos/os/os_timer/os_timer.c
SRC_C += ./demos/peripheral/adc/test_adc.c
SRC_C += ./demos/peripheral/flash/test_flash.c
SRC_C += ./demos/peripheral/gpio/test_gpio.c
SRC_C += ./demos/peripheral/pwm/test_pwm.c
SRC_C += ./demos/wifi/airkiss_station/wifi_Airkiss_station.c
SRC_C += ./demos/wifi/scan/wifi_scan.c
SRC_C += ./demos/wifi/softap/wifi_delete_softap.c
SRC_C += ./demos/wifi/softap/wifi_softap.c
SRC_C += ./demos/wifi/station/wifi_station.c
SRC_C += ./demos/wifi/station_power_save/wifi_station_ps_demo.c
SRC_C += ./demos/demos_start.c

#driver layer
SRC_C += ./beken378/driver/common/dd.c
SRC_C += ./beken378/driver/common/drv_model.c
SRC_C += ./beken378/driver/dma/dma.c
SRC_C += ./beken378/driver/driver.c
SRC_C += ./beken378/driver/entry/arch_main.c
SRC_C += ./beken378/driver/fft/fft.c
SRC_C += ./beken378/driver/flash/flash.c
SRC_C += ./beken378/driver/general_dma/general_dma.c
SRC_C += ./beken378/driver/gpio/gpio.c
SRC_C += ./beken378/driver/i2s/i2s.c
SRC_C += ./beken378/driver/icu/icu.c
SRC_C += ./beken378/driver/intc/intc.c
SRC_C += ./beken378/driver/irda/irda.c
SRC_C += ./beken378/driver/macphy_bypass/mac_phy_bypass.c
SRC_C += ./beken378/driver/phy/phy_trident.c
SRC_C += ./beken378/driver/pwm/pwm.c
SRC_C += ./beken378/driver/pwm/mcu_ps_timer.c
SRC_C += ./beken378/driver/pwm/bk_timer.c
SRC_C += ./beken378/driver/rw_pub/rw_platf_pub.c
SRC_C += ./beken378/driver/saradc/saradc.c
SRC_C += ./beken378/driver/spi/spi.c
SRC_C += ./beken378/driver/spidma/spidma.c
SRC_C += ./beken378/driver/sys_ctrl/sys_ctrl.c
SRC_C += ./beken378/driver/uart/Retarget.c
SRC_C += ./beken378/driver/uart/uart.c
SRC_C += ./beken378/driver/wdt/wdt.c
SRC_C += ./beken378/driver/security/security.c
SRC_C += ./beken378/driver/security/hal_aes.c
SRC_C += ./beken378/driver/security/hal_sha.c

#function layer
SRC_C += ./beken378/func/func.c
SRC_C += ./beken378/func/usb_plug/usb_plug.c
SRC_C += ./beken378/func/security/security_func.c
SRC_C += ./beken378/func/bk7011_cal/bk7231_cal.c
SRC_C += ./beken378/func/bk7011_cal/manual_cal_bk7231.c
SRC_C += ./beken378/func/bk7011_cal/bk7231U_cal.c
SRC_C += ./beken378/func/bk7011_cal/bk7221U_cal.c
SRC_C += ./beken378/func/bk7011_cal/manual_cal_bk7231U.c
SRC_C += ./beken378/func/joint_up/role_launch.c
SRC_C += ./beken378/func/joint_up/reconnect_startup.c
SRC_C += ./beken378/func/hostapd_intf/hostapd_intf.c
SRC_C += ./beken378/func/hostapd-2.5/bk_patch/ddrv.c
SRC_C += ./beken378/func/hostapd-2.5/bk_patch/signal.c
SRC_C += ./beken378/func/hostapd-2.5/bk_patch/sk_intf.c
SRC_C += ./beken378/func/hostapd-2.5/bk_patch/fake_socket.c
SRC_C += ./beken378/func/hostapd-2.5/hostapd/main_none.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-internal.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-internal-dec.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-internal-enc.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-unwrap.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-wrap.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/md5.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/md5-internal.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/rc4.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/sha1.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/sha1-internal.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/sha1-pbkdf2.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/sha1-prf.c
SRC_C += ./beken378/func/hostapd-2.5/src/crypto/tls_none.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ap_config.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ap_drv_ops.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ap_list.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ap_mlme.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/beacon.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/drv_callbacks.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/hostapd.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/hw_features.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ieee802_11_auth.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ieee802_11.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ieee802_11_ht.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ieee802_11_shared.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/ieee802_1x.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/sta_info.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/tkip_countermeasures.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/utils.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/wmm.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/wpa_auth.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/wpa_auth_glue.c
SRC_C += ./beken378/func/hostapd-2.5/src/ap/wpa_auth_ie.c
SRC_C += ./beken378/func/hostapd-2.5/src/common/hw_features_common.c
SRC_C += ./beken378/func/hostapd-2.5/src/common/ieee802_11_common.c
SRC_C += ./beken378/func/hostapd-2.5/src/common/wpa_common.c
SRC_C += ./beken378/func/hostapd-2.5/src/common/notifier.c
SRC_C += ./beken378/func/hostapd-2.5/src/drivers/driver_beken.c
SRC_C += ./beken378/func/hostapd-2.5/src/drivers/driver_common.c
SRC_C += ./beken378/func/hostapd-2.5/src/drivers/drivers.c
SRC_C += ./beken378/func/hostapd-2.5/src/l2_packet/l2_packet_none.c
SRC_C += ./beken378/func/hostapd-2.5/src/rsn_supp/wpa.c
SRC_C += ./beken378/func/hostapd-2.5/src/rsn_supp/wpa_ie.c
SRC_C += ./beken378/func/hostapd-2.5/src/utils/common.c
SRC_C += ./beken378/func/hostapd-2.5/src/utils/eloop.c
SRC_C += ./beken378/func/hostapd-2.5/src/utils/os_none.c
SRC_C += ./beken378/func/hostapd-2.5/src/utils/wpabuf.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/blacklist.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/bss.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/config.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/config_none.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/events.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/main_supplicant.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/notify.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/wmm_ac.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/wpa_scan.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/wpas_glue.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/wpa_supplicant.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/ctrl_iface.c
SRC_C += ./beken378/func/hostapd-2.5/wpa_supplicant/wlan.c

# for WPA3
#SRC_C += ./beken378/func/hostapd-2.5/src/common/sae.c
#SRC_C += ./beken378/func/hostapd-2.5/src/ap/pmksa_cache_auth.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-ctr.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-omac1.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/aes-siv.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/crypto_wolfssl.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/dh_group5.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/dh_groups.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/sha256.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/sha256-internal.c
#SRC_C += ./beken378/func/hostapd-2.5/src/crypto/sha256-prf.c


SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/port/ethernetif.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/port/net.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/port/sys_arch.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/api_lib.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/api_msg.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/err.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/netbuf.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/netdb.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/netifapi.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/sockets.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/api/tcpip.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/def.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/dns.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/inet_chksum.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/init.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ip.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv4/dhcp.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv4/etharp.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv4/icmp.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv4/igmp.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv4/ip4_addr.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv4/ip4.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv4/ip4_frag.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/dhcp6.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/ethip6.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/icmp6.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/inet6.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/ip6_addr.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/ip6.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/ip6_frag.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/mld6.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/ipv6/nd6.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/mem.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/memp.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/netif.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/pbuf.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/raw.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/stats.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/sys.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/tcp.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/tcp_in.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/tcp_out.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/timeouts.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/core/udp.c
SRC_C += ./beken378/func/lwip_intf/lwip-2.0.2/src/netif/ethernet.c
SRC_C += ./beken378/func/lwip_intf/dhcpd/dhcp-server.c
SRC_C += ./beken378/func/lwip_intf/dhcpd/dhcp-server-main.c
SRC_C += ./beken378/func/misc/fake_clock.c
SRC_C += ./beken378/func/misc/target_util.c
SRC_C += ./beken378/func/power_save/power_save.c
SRC_C += ./beken378/func/power_save/manual_ps.c
SRC_C += ./beken378/func/power_save/mcu_ps.c
SRC_C += ./beken378/func/rf_test/rx_sensitivity.c
SRC_C += ./beken378/func/rf_test/tx_evm.c
SRC_C += ./beken378/func/saradc_intf/saradc_intf.c
SRC_C += ./beken378/func/rwnx_intf/rw_ieee80211.c
SRC_C += ./beken378/func/rwnx_intf/rw_msdu.c
SRC_C += ./beken378/func/rwnx_intf/rw_msg_rx.c
SRC_C += ./beken378/func/rwnx_intf/rw_msg_tx.c
SRC_C += ./beken378/func/sim_uart/gpio_uart.c
SRC_C += ./beken378/func/sim_uart/pwm_uart.c
SRC_C += ./beken378/func/spidma_intf/spidma_intf.c
SRC_C += ./beken378/func/temp_detect/temp_detect.c
SRC_C += ./beken378/func/uart_debug/cmd_evm.c
SRC_C += ./beken378/func/uart_debug/cmd_help.c
SRC_C += ./beken378/func/uart_debug/cmd_reg.c
SRC_C += ./beken378/func/uart_debug/cmd_rx_sensitivity.c
SRC_C += ./beken378/func/uart_debug/command_line.c
SRC_C += ./beken378/func/uart_debug/command_table.c
SRC_C += ./beken378/func/uart_debug/udebug.c
SRC_C += ./beken378/func/user_driver/BkDriverFlash.c
SRC_C += ./beken378/func/user_driver/BkDriverGpio.c
SRC_C += ./beken378/func/user_driver/BkDriverPwm.c
SRC_C += ./beken378/func/user_driver/BkDriverUart.c
SRC_C += ./beken378/func/user_driver/BkDriverWdg.c
SRC_C += ./beken378/func/wlan_ui/wlan_cli.c

# For WPA3: wolfssl
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/wolfmath.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/memory.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/tfm.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/ecc.c

# not needed, only ECC is required
##SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/error.c
##SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/integer.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/hmac.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/hash.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/cpuid.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/sha256.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/random.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/rsa.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/aes.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/sha.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/sha512.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/sha3.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/wc_encrypt.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/logging.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/wc_port.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/signature.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/asn.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/dh.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/coding.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/poly1305.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/md5.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/md4.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/chacha.c
#SRC_C += ./beken378/func/wolfssl/wolfcrypt/src/chacha20_poly1305.c
#SRC_C += ./beken378/func/wolfssl/src/internal.c
#SRC_C += ./beken378/func/wolfssl/src/wolfio.c
#SRC_C += ./beken378/func/wolfssl/src/keys.c
#SRC_C += ./beken378/func/wolfssl/src/ssl.c
#SRC_C += ./beken378/func/wolfssl/src/tls.c

SRC_C += ./beken378/func/wlan_ui/wlan_ui.c
SRC_C += ./beken378/func/net_param_intf/net_param.c
SRC_C += ./beken378/func/base64/base_64.c
SRC_C += ./beken378/func/airkiss/bk_airkiss.c
SRC_C += ./beken378/func/airkiss/airkiss_main.c
SRC_C += ./beken378/func/airkiss/airkiss_pingpong.c

#easy flash
SRC_C += ./beken378/func/easy_flash/bk_ef.c
SRC_C += ./beken378/func/easy_flash/src/easyflash.c
SRC_C += ./beken378/func/easy_flash/src/ef_env.c
SRC_C += ./beken378/func/easy_flash/src/ef_env_wl.c
SRC_C += ./beken378/func/easy_flash/src/ef_iap.c
SRC_C += ./beken378/func/easy_flash/src/ef_log.c
SRC_C += ./beken378/func/easy_flash/src/ef_utils.c
SRC_C += ./beken378/func/easy_flash/port/ef_port.c

#paho-mqtt
SRC_C += ./beken378/func/paho-mqtt/client/src/MQTTClient.c
SRC_C += ./beken378/func/paho-mqtt/client/src/MQTTFreeRTOS.c
SRC_C += ./beken378/func/paho-mqtt/client/paho_mqtt_udp.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTConnectClient.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTConnectServer.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTDeserializePublish.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTFormat.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTPacket.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTSerializePublish.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTSubscribeClient.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTSubscribeServer.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTUnsubscribeClient.c
SRC_C += ./beken378/func/paho-mqtt/packet/src/MQTTUnsubscribeServer.c

#rwnx ip module


#rwnx ble module


BLE_C += ./beken378/driver/ble/ble.c
BLE_C += ./beken378/driver/ble/ble_pub/ip/ble/hl/src/prf/prf.c
BLE_C += ./beken378/driver/ble/ble_pub/ip/ble/profiles/sdp/src/sdp_service.c
BLE_C += ./beken378/driver/ble/ble_pub/ip/ble/profiles/sdp/src/sdp_service_task.c
BLE_C += ./beken378/driver/ble/ble_pub/ip/ble/profiles/comm/src/comm.c
BLE_C += ./beken378/driver/ble/ble_pub/ip/ble/profiles/comm/src/comm_task.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/app/src/app_ble.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/app/src/app_task.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/app/src/app_sdp.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/app/src/app_sec.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/app/src/app_comm.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/common/src/common_list.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/common/src/common_utils.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/common/src/RomCallFlash.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/dbg/src/dbg.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/dbg/src/dbg_mwsgen.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/dbg/src/dbg_swdiag.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/dbg/src/dbg_task.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/rwip/src/rwip.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/rf/src/ble_rf_xvr.c
BLE_C += ./beken378/driver/ble/ble_pub/modules/ecc_p256/src/ecc_p256.c
BLE_C += ./beken378/driver/ble/ble_pub/plf/refip/src/driver/uart/uart.c           

#operation system module
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/croutine.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/event_groups.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/list.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/portable/Keil/ARM968es/port.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/portable/MemMang/heap_4.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/queue.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/tasks.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/FreeRTOS/Source/timers.c
SRC_OS += ./beken378/os/FreeRTOSv9.0.0/rtos_pub.c
SRC_C  += ./beken378/os/mem_arch.c
SRC_C  += ./beken378/os/str_arch.c

ifeq ($(CFG_SUPPORT_BLE),1)
SRC_C += $(BLE_C)
endif

#examples for customer

#assembling files
SRC_S = 
SRC_S +=  ./beken378/driver/entry/boot_handlers.S
SRC_S +=  ./beken378/driver/entry/boot_vectors.S

# Generate obj list
# -------------------------------------------------------------------
OBJ_LIST = $(SRC_C:%.c=$(OBJ_DIR)/%.o)
DEPENDENCY_LIST = $(SRC_C:%.c=$(OBJ_DIR)/%.d)

OBJ_S_LIST = $(SRC_S:%.S=$(OBJ_DIR)/%.O)
DEPENDENCY_S_LIST = $(SRC_S:%.S=$(OBJ_DIR)/%.d)

OBJ_OS_LIST = $(SRC_OS:%.c=$(OBJ_DIR)/%.marm.o)
DEPENDENCY_OS_LIST = $(SRC_OS:%.c=$(OBJ_DIR)/%.d)

ifeq ($(SOC_NAME), 1)
SOC_NAME_ELF = beken7231.elf
SOC_NAME_BIN = beken7231.bin
SOC_NAME_MAP = beken7231.map
else ifeq ($(SOC_NAME), 2)
SOC_NAME_ELF = beken7231u.elf
SOC_NAME_BIN = beken7231u.bin
SOC_NAME_MAP = beken7231u.map
else ifeq ($(SOC_NAME), 3)
SOC_NAME_ELF = beken7251.elf
SOC_NAME_BIN = beken7251.bin
SOC_NAME_MAP = beken7251.map
endif

# Compile options
# -------------------------------------------------------------------
CFLAGS =
CFLAGS += -g -mthumb -mcpu=arm968e-s -march=armv5te -mthumb-interwork -mlittle-endian -Os -std=c99 -ffunction-sections -Wall -fsigned-char -fdata-sections -Wunknown-pragmas -nostdlib -Wno-unused-function -Wno-unused-but-set-variable
#CFLAGS += -g -mthumb -mcpu=arm968e-s -march=armv5te -mthumb-interwork -mlittle-endian -Os -std=c99 -ffunction-sections -Wall -Wno-unused-function -fsigned-char -fdata-sections -Wunknown-pragmas -nostdlib -Wl,--gc-sections

OSFLAGS =
OSFLAGS += -g -marm -mcpu=arm968e-s -march=armv5te -mthumb-interwork -mlittle-endian -Os -std=c99 -ffunction-sections -Wall -fsigned-char -fdata-sections -Wunknown-pragmas
#OSFLAGS += -g -mthumb -mcpu=arm968e-s -march=armv5te -mthumb-interwork -mlittle-endian -Os -std=c99 -ffunction-sections -Wall -fsigned-char -fdata-sections -Wunknown-pragmas -Wl,--gc-sections

ASMFLAGS = 
ASMFLAGS += -g -marm -mthumb-interwork -mcpu=arm968e-s -march=armv5te -x assembler-with-cpp

LFLAGS = 
LFLAGS += -g -Wl,--gc-sections -marm -mcpu=arm968e-s -mthumb-interwork -nostdlib
#LFLAGS += -g -Wl,--gc-sections -mthumb -mcpu=arm968e-s -mthumb-interwork -nostdlib

# For WPA3
# Wolfssl cflags
# WOLFSSL_CFLAGS += -DBUILDING_WOLFSSL -DHAVE_FFDHE_2048 -D_POSIX_THREADS -DHAVE_THREAD_LS -DNDEBUG \
		  -DTFM_TIMING_RESISTANT -DECC_TIMING_RESISTANT -DWC_RSA_BLINDING -DHAVE_AESGCM -DWOLFSSL_SHA512 \
		  -DWOLFSSL_SHA384 -DNO_DSA -DHAVE_ECC -DTFM_ECC256 -DECC_SHAMIR -DWOLFSSL_BASE64_ENCODE -DNO_RC4 \
		  -DNO_HC128 -DNO_RABBIT -DWOLFSSL_SHA224 -DWOLFSSL_SHA3 -DHAVE_POLY1305 -DHAVE_ONE_TIME_AUTH \
		  -DHAVE_CHACHA -DHAVE_HASHDRBG -DHAVE_TLS_EXTENSIONS -DHAVE_SUPPORTED_CURVES -DHAVE_EXTENDED_MASTER \
		  -DNO_PSK -DNO_PWDBASED -DUSE_FAST_MATH -DWOLFSSL_X86_64_BUILD -DWC_NO_ASYNC_THREADING -DNO_DES3 -DNO_WOLFSSL_DIR \
		  -DWOLFSSL_NO_ASM -DWOLFSSL_NO_SOCK -DNNO_CERTS -DNO_WRITEV -DNO_ERROR_STRINGS -DWOLFSSL_SMALL_STACK \
		  -DHAVE_COMP_KEY
# CFLAGS += $(WOLFSSL_CFLAGS)

LIBFLAGS =
#LIBFLAGS += -L./beken378/ip/ -lip

#LIBFLAGS += -L./beken378/ip/ -lrwnx
#LIBFLAGS += -L./beken378/driver/ble -lble

LIBFLAGS += -L./beken378/lib/ -lrwnx
LIBFLAGS += -L./beken378/lib/ -lble

LIBFLAGS += -L./beken378/func/airkiss -lairkiss


CUR_PATH = $(shell pwd)
.PHONY: application
application: $(OBJ_LIST) $(OBJ_S_LIST) $(OBJ_OS_LIST)
	@echo LD $(BIN_DIR)/$(SOC_NAME_ELF)
	@$(LD) $(LFLAGS) -o $(BIN_DIR)/$(SOC_NAME_ELF) $(OBJ_LIST) $(OBJ_S_LIST) $(OBJ_OS_LIST) $(LIBFLAGS) -T./build/bk7231_ota.ld -Xlinker -Map=$(BIN_DIR)/$(SOC_NAME_MAP)
	$(OBJCOPY) -O binary $(BIN_DIR)/$(SOC_NAME_ELF) $(BIN_DIR)/$(SOC_NAME_BIN)
#	$(OBJDUMP) -d $(BIN_DIR)/$(SOC_NAME_ELF) >> $(BIN_DIR)/beken7231.asm
	@echo "                                                        "
	@echo "crc binary operation"
	$(ENCRYPT) $(BIN_DIR)/$(SOC_NAME_BIN) 0 $(ENCRYPT_ARGS)

# Generate build info
# -------------------------------------------------------------------	

$(OBJ_DIR)/%.o: %.c
	$(Q)if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	$(Q)echo CC $<
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	$(Q)$(CC) $(CFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(patsubst %.o,%.d,$@)

$(OBJ_DIR)/%.O: %.S
	$(Q)if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	$(Q)echo AS $<
	$(Q)$(CC) $(ASMFLAGS) $(INCLUDES) -c $< -o $@
	$(Q)$(CC) $(ASMFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(patsubst %.O,%.d,$@)

$(OBJ_DIR)/%.marm.o: %.c
	$(Q)if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi
	$(Q)echo CC $<
	$(Q)$(CC) $(OSFLAGS) $(INCLUDES) -c $< -o $@
	$(Q)$(CC) $(OSFLAGS) $(INCLUDES) -c $< -MM -MT $@ -MF $(patsubst %.marm.o,%.d,$@)

-include $(DEPENDENCY_LIST)
-include $(DEPENDENCY_S_LIST)
-include $(DEPENDENCY_OS_LIST)
	
.PHONY: clean
clean:
	rm -rf $(TARGET)
