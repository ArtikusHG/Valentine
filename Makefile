DEBUG = 0
FINALPACKAGE = 1

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = armv7 arm64 arm64e
#THEOS_DEVICE_IP = 192.168.0.18

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Valentine

Valentine_FILES = Tweak.x
Valentine_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
