DEBUG = 0
FINALPACKAGE = 1

TARGET := iphone:clang:latest:10.0
INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = armv7 arm64
THEOS_DEVICE_IP = 192.168.0.34
#THEOS_DEVICE_IP = 127.0.0.1
#THEOS_DEVICE_PORT = 2222

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Valentine

Valentine_FILES = Tweak.x
Valentine_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
