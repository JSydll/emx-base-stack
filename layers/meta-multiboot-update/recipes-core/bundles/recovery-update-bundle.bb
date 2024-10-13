# -------------------------------------------------------------------
# Recovery software update bundle
# -------------------------------------------------------------------
SUMMARY = "Recovery software update bundle."

LICENSE = "MIT"

inherit bundle
require bundle-common.inc

RAUC_BUNDLE_DESCRIPTION = "Recovery update bundle for the ${PRODUCT_NAME}"

RAUC_BUNDLE_SLOTS ?= "recoveryBoot recovery"

RAUC_SLOT_recoveryBoot ?= "${RAUC_ARTIFACT_SOURCE}"
RAUC_SLOT_recoveryBoot[type] = "image"
RAUC_SLOT_recoveryBoot[fstype] = "wic.recovery.boot.vfat"

RAUC_SLOT_recovery ?= "${RAUC_ARTIFACT_SOURCE}"
RAUC_SLOT_recovery[type] = "image"
RAUC_SLOT_recovery[fstype] = "wic.recovery.rootfs.img"