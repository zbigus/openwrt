# SPDX-License-Identifier: GPL-2.0-only

include ./common.mk

define Device/d-link_dgs-1210-52
  $(Device/d-link_dgs-1210)
  SOC := rtl8393
  DEVICE_MODEL := DGS-1210-52
endef
TARGET_DEVICES += d-link_dgs-1210-52

# When the factory image won't fit anymore, it can be removed.
# New installation will be performed booting the initramfs image from
# ram and then flashing the sysupgrade image from OpenWrt
define Device/netgear_gs750e
  SOC := rtl8393
  IMAGE_SIZE := 7552k
  FACTORY_SIZE := 6528k
  DEVICE_VENDOR := NETGEAR
  DEVICE_MODEL := GS750E
  UIMAGE_MAGIC := 0x174e4741
  IMAGES += factory.bix
  IMAGE/factory.bix := \
    append-kernel | \
    pad-to 64k | \
    append-rootfs | \
    pad-rootfs | \
    check-size $$$$(FACTORY_SIZE)
endef
TARGET_DEVICES += netgear_gs750e

define Device/panasonic_m48eg-pn28480k
  SOC := rtl8393
  IMAGE_SIZE := 16384k
  DEVICE_VENDOR := Panasonic
  DEVICE_MODEL := Switch-M48eG
  DEVICE_VARIANT := PN28480K
  DEVICE_PACKAGES := \
	kmod-hwmon-gpiofan \
	kmod-hwmon-lm75 \
	kmod-i2c-mux-pca954x \
	kmod-thermal
endef
TARGET_DEVICES += panasonic_m48eg-pn28480k

define Device/tplink_sg2452p-v4
  SOC := rtl8393
  KERNEL_SIZE := 6m
  IMAGE_SIZE := 26m
  DEVICE_VENDOR := TP-Link
  DEVICE_MODEL := SG2452P
  DEVICE_VARIANT := v4
  DEVICE_PACKAGES := \
	  kmod-hwmon-gpiofan \
	  kmod-hwmon-tps23861
endef
TARGET_DEVICES += tplink_sg2452p-v4

define Device/zyxel_gs1900-48
  $(Device/zyxel_gs1900)
  SOC := rtl8393
  DEVICE_MODEL := GS1900-48
  ZYXEL_VERS := AAHN
endef
TARGET_DEVICES += zyxel_gs1900-48

define Device/zyxel_gs1920-24hp
  SOC := rtl8392
  DEVICE_VENDOR := ZyXEL
  DEVICE_MODEL := GS1920-24HP
  COMPILE := loader-$(1).bin
  COMPILE/loader-$(1).bin := loader-okli-compile | zynsig | pad-to 64k
  ARTIFACTS := loader.bin
  ARTIFACT/loader.bin := append-loader-okli $(1)
  LOADER_TYPE := bin
  LOADER_FLASH_OFFS := 0xc0000
  IMAGE_SIZE := 7405568
  IMAGES += factory.bin
  IMAGE/factory.bin := \
	append-loader-okli $(1) | \
    append-kernel | \
	pad-to 64k | \
	append-rootfs | \
	pad-rootfs
  KERNEL := \
	kernel-bin | \
	append-dtb | \
	lzma | \
	uImage lzma -M 0x4f4b4c49
  KERNEL_INITRAMFS := \
	kernel-bin | \
	append-dtb | \
	lzma | \
	loader-kernel
endef
TARGET_DEVICES += zyxel_gs1920-24hp
