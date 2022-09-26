# -------------------------------------------------------------------
# System software update bundle
# -------------------------------------------------------------------
SUMMARY = "System software update bundle."

LICENSE = "MIT"

inherit bundle
require bundle-common.inc

RAUC_BUNDLE_DESCRIPTION = "System update bundle for the ${PRODUCT_NAME}"

RAUC_BUNDLE_SLOTS ?= "systemBoot system"

RAUC_SLOT_systemBoot ?= "${RAUC_ARTIFACT_SOURCE}"
RAUC_SLOT_systemBoot[type] = "image"
RAUC_SLOT_systemBoot[fstype] = "wic.system.boot.vfat"

RAUC_SLOT_system ?= "${RAUC_ARTIFACT_SOURCE}"
RAUC_SLOT_system[type] = "image"
RAUC_SLOT_system[fstype] = "wic.system.rootfs.ext4"