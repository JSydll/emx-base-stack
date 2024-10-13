# -----------------------------------------------
# Multiboot partition scheme variable definitions
# -----------------------------------------------

DEPENDS += " \
    rpi-bootloader-files \
"

WIC_DEVICE="${MMC_BLOCK_DEVICE}"

# Bootloader
WIC_BOOTLOADER_PART_SIZE = "25M"
WIC_BOOTLOADER_PART_CMD = "\
    /boot   --source extract-from-archive --sourceparams='file=rpi-bootloader-files.tar.gz' \
            --fstype=vfat --label boot --active --align 4096 --fixed-size ${WIC_BOOTLOADER_PART_SIZE}\
"
WIC_BOOTLOADER_EXTRA_PART_CMD = ""
WIC_BOOTLOADER_ENV_PART_CMD = ""
WIC_BOOTLOADER_CONFIG = "--ptable ${PTABLE_TYPE}"

# Software partitions
WIC_FIRST_PARTITION_OFFSET = "" 
WIC_KERNELIMG_PART_SIZE = "50M"
WIC_KERNELIMG_SOURCE = "--source bootimg-partition"
WIC_RECOVERY_ROOTFS_PART_SIZE = "150M"
WIC_RECOVERY_ROOTFS_SOURCE = "--source rootfs --rootfs-dir ${RECOVERY_IMAGE_NAME}"
WIC_SYSTEM_ROOTFS_PART_SIZE = "400M"
WIC_SYSTEM_ROOTFS_SOURCE = "--source rootfs --rootfs-dir ${SYSTEM_IMAGE_NAME}"
WIC_APPFS_MIN_PART_SIZE = "100M"