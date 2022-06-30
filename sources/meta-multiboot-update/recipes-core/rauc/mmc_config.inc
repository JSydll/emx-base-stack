RECOVERY_BOOT_DEVICE = "/dev/${MMC_BLOCK_DEVICE}p2"
RECOVERY_DEVICE = "/dev/${MMC_BLOCK_DEVICE}p3"
SYSTEM_BOOT_DEVICE = "/dev/${MMC_BLOCK_DEVICE}p${@ bb.utils.contains('PTABLE_TYPE', 'msdos', '5', '4', d) }"
SYSTEM_DEVICE = "/dev/${MMC_BLOCK_DEVICE}p${@ bb.utils.contains('PTABLE_TYPE', 'msdos', '6', '5', d) }"