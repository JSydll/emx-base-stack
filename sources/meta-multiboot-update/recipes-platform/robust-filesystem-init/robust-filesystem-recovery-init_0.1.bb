# Allows the separation of software mode specific data and the adjustment of the filesystem
RPROVIDES:${PN} = "robust-filesystem-init"

FS_INIT_SOFTWARE_MODE = "recovery"

require robust-filesystem-init.inc