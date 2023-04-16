inherit robust-filesystem-init-env

FS_INIT_PERSISTENT_DEVICE = "/dev/${MMC_BLOCK_DEVICE}p${FS_PERSISTENT_PARTITION_OFFSET}"

do_install:append() {
    # Provide access to the bootloader environment on the boot partition
    printf "/dev/${MMC_BLOCK_DEVICE}p1    /boot   vfat    defaults    0 0\n\n" >> ${D}/${sysconfdir}/fstab
}