# --------------------------------------------------------------------------------
# Reusable class to create a full image containing recovery and system sub-images.
# --------------------------------------------------------------------------------
SUMMARY = "Reusable class to create a full image / rootfs."

LICENSE = "MIT"

# Define an empty image as the contents of the multiboot image shall be 
# taken from distinct image recipes.

IMAGE_FEATURES = ""
IMAGE_INSTALL = ""
PACKAGE_INSTALL = ""

inherit image

RECOVERY_IMAGE_NAME ?= "recovery-image"
SYSTEM_IMAGE_NAME ?= "system-image"

WKS_FILE = "${STORAGE_TYPE}-multiboot.wks.in"
IMAGE_FSTYPES = "wic wic.bz2"

DEPENDS += " \
    ${RECOVERY_IMAGE_NAME} \
    ${SYSTEM_IMAGE_NAME} \
"

# Enforce the images of the respective modes complete before building the integrated image.
do_rootfs[depends] += "\
    ${RECOVERY_IMAGE_NAME}:do_image_complete \
    ${SYSTEM_IMAGE_NAME}:do_image_complete \
"

require board-definitions/${MACHINE}.inc