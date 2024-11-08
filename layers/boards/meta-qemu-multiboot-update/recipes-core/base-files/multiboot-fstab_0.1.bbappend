# Provide access to the bootloader environment on the boot-env partition
do_install:append() {
    install -d -m 0644 ${D}/boot
    printf "/dev/vda1    /boot   vfat    defaults    0 0\n\n" >> ${D}/${sysconfdir}/fstab
}

FILES:${PN} += " \
    /boot \
"