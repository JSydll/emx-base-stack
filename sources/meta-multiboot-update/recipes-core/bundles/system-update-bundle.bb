# -------------------------------------------------------------------
# System software update bundle
# -------------------------------------------------------------------
SUMMARY = "System software update bundle."

LICENSE = "MIT"

inherit bundle

DEPENDS += "${SYSTEM_IMAGE_NAME}"

require bundle-meta-info.inc

RAUC_BUNDLE_DESCRIPTION = "System update Bundle for the ${PRODUCT_NAME}"

RAUC_BUNDLE_SLOTS ?= "systemBoot system"
RAUC_SLOT_systemBoot ?= "${SYSTEM_IMAGE_NAME}"
RAUC_SLOT_systemBoot[type] = "image"
RAUC_SLOT_systemBoot[fstype] = "wic.boot.vfat"

RAUC_SLOT_system ?= "${SYSTEM_IMAGE_NAME}"
RAUC_SLOT_system[type] = "image"
RAUC_SLOT_system[fstype] = "wic.rootfs.ext4"