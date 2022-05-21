# Account for the extended partitioning layout in case msdos partition tables are used
APPFS_PARTITION = "${@bb.utils.contains('PTABLE_TYPE', 'msdos', '7', '6', d)}"

do_install_append() {
    # Mount boot and appfs partitions
    echo "/dev/${MMC_BLOCK_DEVICE}p1                    /boot     vfat defaults                         0 0"   >> ${D}${sysconfdir}/fstab
    echo "/dev/${MMC_BLOCK_DEVICE}p${APPFS_PARTITION}   /var/app  ext4 defaults,sync,nofail,noatime,rw  0 0\n" >> ${D}${sysconfdir}/fstab
}