# -----------------------------------------------
# Multiboot partition scheme variable definitions
# -----------------------------------------------

DEPENDS += " \
    efi-boot-image \
"

WIC_DEVICE="sda"

# Bootloader
WIC_BOOTLOADER_PART_SIZE = "50M"
WIC_BOOTLOADER_PART_CMD = "\
    --source rawcopy --sourceparams='file=efi-boot.vfat' \
    --fstype=vfat --label boot --active --align 4096 --fixed-size ${WIC_BOOTLOADER_PART_SIZE} \
"
# Extra partition for bootloader updates
WIC_BOOTLOADER_EXTRA_PART_CMD = "\
    part --ondisk ${WIC_DEVICE} --fixed-size ${WIC_BOOTLOADER_PART_SIZE} --align 4096 --no-table\
"
WIC_BOOTLOADER_CONFIG = "--ptable ${PTABLE_TYPE}"

# Unfortunately, we can't use the automatic image-based lookup provided by wic if we specify an exclude-path -
# therefore, we need to manually specify expected paths (which are stable though).
SYSTEM_IMAGE_ROOTFS_PATH = "${BASE_WORKDIR}/${MULTIMACH_TARGET_SYS}/${SYSTEM_IMAGE_NAME}/1.0-r0/rootfs"
RECOVERY_IMAGE_ROOTFS_PATH = "${BASE_WORKDIR}/${MULTIMACH_TARGET_SYS}/${RECOVERY_IMAGE_NAME}/1.0-r0/rootfs"

# Software partitions
WIC_FIRST_PARTITION_OFFSET = "" 
WIC_KERNELIMG_PART_SIZE = "50M"
# The kernel image will be deployed in the rootfs
WIC_KERNELIMG_SOURCE = "--source rootfs --rootfs-dir ${SYSTEM_IMAGE_ROOTFS_PATH}/boot"
WIC_RECOVERY_ROOTFS_PART_SIZE = "150M"
WIC_RECOVERY_ROOTFS_SOURCE = "--source rootfs --rootfs-dir ${RECOVERY_IMAGE_ROOTFS_PATH} --exclude-path boot/"
WIC_SYSTEM_ROOTFS_PART_SIZE = "400M"
WIC_SYSTEM_ROOTFS_SOURCE = "--source rootfs --rootfs-dir ${SYSTEM_IMAGE_ROOTFS_PATH} --exclude-path boot/"
WIC_APPFS_MIN_PART_SIZE = "100M"