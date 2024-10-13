# Provide access to the bootloader environment on the boot partition
do_install:append() {
    printf "/dev/${MMC_BLOCK_DEVICE}p1    /boot   vfat    defaults    0 0\n\n" >> ${D}/${sysconfdir}/fstab
}