do_install_append() {
    # Mount boot and appfs partitions
    echo "/dev/${MMC_BLOCK_DEVICE}p1 /boot     vfat defaults                         0 0"   >> ${D}${sysconfdir}/fstab
    echo "/dev/${MMC_BLOCK_DEVICE}p7 /var/app  ext4 defaults,sync,nofail,noatime,rw  0 0\n" >> ${D}${sysconfdir}/fstab
}