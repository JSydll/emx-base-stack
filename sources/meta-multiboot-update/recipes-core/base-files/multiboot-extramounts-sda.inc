# Provide access to the bootloader environment on the boot partition
do_install:append() {
    printf "/dev/sda$1    /boot   vfat    defaults    0 0\n\n" >> ${D}/${sysconfdir}/fstab
}