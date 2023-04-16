inherit robust-filesystem-init-env

FS_INIT_PERSISTENT_DEVICE = "/dev/sda${FS_PERSISTENT_PARTITION_OFFSET}"

do_install:append() {
    # Provide access to the bootloader environment on the boot partition
    printf "/dev/sda1    /boot   vfat    defaults    0 0\n\n" >> ${D}/${sysconfdir}/fstab
}