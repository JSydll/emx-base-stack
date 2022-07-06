# -----------------------------------------------
# Multiboot partition scheme variable definitions
# -----------------------------------------------

DEPENDS += " \
    rpi-bootloader-files \
"

WIC_BOOTLOADER_PART_CMD = "\
    --source extract-from-archive --sourceparams='file=rpi-bootloader-files.tar.gz' \
    --fstype=vfat --label boot --active --align 4096 --fixed-size 25M\
"
WIC_TARGET_BOOTLOADER_CONFIG = "--ptable ${PTABLE_TYPE}"
WIC_FIRST_PARTITION_OFFSET = "4M" 
WIC_KERNELIMG_PART_SIZE = "50M"
WIC_RECOVERY_ROOTFS_PART_SIZE = "150M"
WIC_SYSTEM_ROOTFS_PART_SIZE = "400M"
WIC_APPFS_MIN_PART_SIZE = "100M"