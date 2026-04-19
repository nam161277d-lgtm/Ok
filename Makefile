DEBUG = 0
FINALPACKAGE = 1
TWEAK_NAME = VIP_AIM_BINPRO

# Khai báo file mã nguồn chính
VIP_AIM_BINPRO_FILES = Tweak.x

# Các thư viện hệ thống cần thiết để vẽ Menu và Tia ESP
VIP_AIM_BINPRO_FRAMEWORKS = UIKit CoreGraphics QuartzCore

# Cấu trúc chip cho iPhone 14 Pro Max (A16)
ARCHS = arm64 arm64e

# Phiên bản iOS mục tiêu
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
