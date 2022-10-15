# System capabilities
ENABLE_UART = "1"
DISABLE_SPLASH = "1"
DISABLE_RPI_BOOT_LOGO = "1"

DISTRO_FEATURES:append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"
VIRTUAL-RUNTIME_initscripts = ""

# Memory and partition table properties
STORAGE_TYPE="mmc"
MMC_BLOCK_DEVICE="mmcblk0"
PTABLE_TYPE = "msdos"

# Bootloader settings
RPI_USE_U_BOOT = "1"
PREFERRED_PROVIDER_virtual/bootloader = "u-boot"
PREFERRED_RPROVIDER_u-boot-default-env = "libubootenv"

# Bootloader files handling
# Note: This will only work if the rpi-bootloader-files are deployed!

# Set of bootloader files
RPI_BOOTLOADER_FILES = "${BOOTFILES_DIR_NAME}/* boot.scr u-boot.bin"

# Remove from IMAGE_BOOT_FILES (as these can then be used with wic's 
# bootimg-partition to create kernel partitions), also accounting for 
# renaming of u-boot.bin.
IMAGE_BOOT_FILES:remove = "${RPI_BOOTLOADER_FILES};${SDIMG_KERNELIMAGE}" 

# The sdcard_image-rpi.bbclass uses a slight hack to have u-boot as bootloader: It stores u-boot.bin
# as ${SDIMG_KERNELIMAGE} (board-specific kernel image name) so no changes in config.txt are needed.
# But we set the kernel name explicit to make this more transparent.
RPI_EXTRA_CONFIG:append = " \n# Enforce u-boot as 4th-stage bootloader \nkernel=u-boot.bin \n"

# Image features
IMAGE_INSTALL:append = " \
    linux-firmware-bcm43430 \
    i2c-tools \
"

# Rotate the display for use with 7' LCD
DISPLAY_ROTATE = "2"