# -------------------
# Configures an image to use the robust filesystem initialization.
# -------------------

inherit logging

RDEPENDS:${PN} += " \
    robust-filesystem-init \
"

# Note: Directly appending to do_rootfs does not work with shell code as the function is written in Python.
# This approach is strongly aligned with https://git.yoctoproject.org/poky/tree/meta/classes/overlayfs-etc.bbclass
# (however, the extended implementation in the pre-init script prevents simple reusage).

inject_pre_init() {
    bbnote "Configuring image to use the robust filesystem initialization (including customized fstab)."
    
    # Inject the pre-init script before the actual init
    if [ -f "${IMAGE_ROOTFS}/sbin/${FS_PRE_INIT_NAME}" ]; then
        mv "${IMAGE_ROOTFS}/sbin/init"                "${IMAGE_ROOTFS}/sbin/${FS_ORIGINAL_INIT_NAME}"
        mv "${IMAGE_ROOTFS}/sbin/${FS_PRE_INIT_NAME}" "${IMAGE_ROOTFS}/sbin/init"
    fi  
}

ROOTFS_POSTPROCESS_COMMAND += "inject_pre_init; "