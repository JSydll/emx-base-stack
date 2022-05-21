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

IMAGE_FSTYPES = "wic.bz2"
WKS_FILE = "${STORAGE_TYPE}-multiboot.wks.in"

DEPENDS += " \
    recovery-image \
    system-image \
"

# Enforce the images of the respective modes complete before building the integrated image.
do_rootfs[depends] += "\
    recovery-image:do_image_complete \
    system-image:do_image_complete \
"