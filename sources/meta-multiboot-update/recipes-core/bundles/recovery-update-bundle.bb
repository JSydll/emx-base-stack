# -------------------------------------------------------------------
# Recovery software update bundle
# -------------------------------------------------------------------
SUMMARY = "Recovery software update bundle."

LICENSE = "MIT"

inherit bundle

DEPENDS += "${RECOVERY_IMAGE_NAME}"

require bundle-meta-info.inc

RAUC_BUNDLE_DESCRIPTION = "Recovery update Bundle for the ${PRODUCT_NAME}"

RAUC_BUNDLE_SLOTS ?= "recoveryBoot recovery"
RAUC_SLOT_recoveryBoot ?= "${RECOVERY_IMAGE_NAME}"
RAUC_SLOT_recoveryBoot[type] = "image"
RAUC_SLOT_recoveryBoot[fstype] = "wic.boot.vfat"

RAUC_SLOT_recovery ?= "${RECOVERY_IMAGE_NAME}"
RAUC_SLOT_recovery[type] = "image"
RAUC_SLOT_recovery[fstype] = "wic.rootfs.img"