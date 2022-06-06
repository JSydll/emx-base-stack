# System capabilities
ENABLE_UART = "1"
DISABLE_SPLASH = "1"
DISABLE_RPI_BOOT_LOGO = "1"

DISTRO_FEATURES_append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"
VIRTUAL-RUNTIME_initscripts = ""

# Storage and partitioning
STORAGE_TYPE = "mmc"
MMC_BLOCK_DEVICE = "/dev/mmcblk0"
PTABLE_TYPE = "msdos"

# u-boot settings
RPI_USE_U_BOOT = "1"
PREFERRED_PROVIDER_virtual/bootloader = "u-boot"
PREFERRED_RPROVIDER_u-boot-default-env = "libubootenv"

# The sdcard_image-rpi.bbclass uses a slight hack to have u-boot as bootloader: It stores u-boot.bin
# as ${SDIMG_KERNELIMAGE} (board-specific kernel image name) so no changes in config.txt are needed.
# But we set the kernel name explicit to make this more transparent.
RPI_EXTRA_CONFIG_append = " \n# Enforce u-boot as 4th-stage bootloader \nkernel=u-boot.bin \n"

# Extensions
IMAGE_CLASSES_append = " bootloader-image-rpi"

# Image features
IMAGE_INSTALL_append = " linux-firmware-bcm43430 i2c-tools"