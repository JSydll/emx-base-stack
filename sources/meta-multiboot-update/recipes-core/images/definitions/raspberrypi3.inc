# -----------------------------------------------
# Multiboot partition scheme variable definitions
# -----------------------------------------------
DEPENDS += " \
    bootloader-image-rpi \
"
do_rootfs[depends] += "\
    bootloader-image-rpi:do_image_complete \
"

WIC_BOOTLOADER_PART_CMD = "\
    --source rawcopy --sourceparams='file=bootloader-image-rpi-raspberrypi3.vfat' \
    --fstype=vfat --label boot --active --align 4096 --size 20\
"
WIC_TARGET_BOOTLOADER_CONFIG = "--ptable ${PTABLE_TYPE}"
WIC_FIRST_PARTITION_OFFSET = "4M" 
WIC_KERNELIMG_PART_SIZE = "20M"
WIC_RECOVERY_ROOTFS_PART_SIZE = "150M"
WIC_SYSTEM_ROOTFS_PART_SIZE = "400M"
WIC_APPFS_PART_SIZE = "4G"