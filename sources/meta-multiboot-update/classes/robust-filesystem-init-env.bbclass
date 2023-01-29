# Common variables for the robust filesystem initialization
FS_INIT_PRE_INIT_NAME  = "pre-init"
FS_INIT_ORIGINAL_INIT_NAME = "init.orig"

# Account for the extended partitioning layout in case msdos partition tables are used
FS_PERSISTENT_PARTITION_OFFSET = "${@bb.utils.contains('PTABLE_TYPE', 'msdos', '7', '6', d)}"