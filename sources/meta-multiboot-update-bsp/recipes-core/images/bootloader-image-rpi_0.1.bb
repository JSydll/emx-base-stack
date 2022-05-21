# -------------------------------------------------------------------
# Image containing only the bootlaoder for the Raspberry Pi
# -------------------------------------------------------------------
SUMMARY = "Image containing only the bootlaoder for the Raspberry Pi."

LICENSE = "MIT"

# Define an empty image as the contents of the image will be produced by the image class.
IMAGE_FEATURES = ""
IMAGE_INSTALL = ""
PACKAGE_INSTALL = ""

inherit image

IMAGE_FSTYPES = "bootloader_image-rpi"