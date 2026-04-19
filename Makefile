DEBUG = 0
FINALPACKAGE = 1
TWEAK_NAME = VIP_AIM_BINPRO

VIP_AIM_BINPRO_FILES = Tweak.x
VIP_AIM_BINPRO_FRAMEWORKS = UIKit CoreGraphics QuartzCore

ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
