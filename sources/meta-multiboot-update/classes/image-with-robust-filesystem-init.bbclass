# -------------------
# Configures an image to use the robust filesystem initialization.
# -------------------

inherit logging

FS_INIT_RECIPE_NAME[doc] = "Specifies the recipe used to deploy the filesystem initialization."

python () {
    if d.getVar('FS_INIT_RECIPE_NAME', True) == "":
        bb.fatal("Please choose a fileystem initialization recipe (FS_INIT_RECIPE_NAME not set)!")
}

IMAGE_INSTALL += " \
    ${FS_INIT_RECIPE_NAME} \
"

inherit robust-filesystem-init-env

# Note: Directly appending to do_rootfs does not work with shell code as the function is written in Python.
# This approach is strongly aligned with https://git.yoctoproject.org/poky/tree/meta/classes/overlayfs-etc.bbclass
# (however, the extended implementation in the pre-init script prevents simple reusage).

inject_pre_init() {
    bbnote "Configuring image to use the robust filesystem initialization (including customized fstab)."
    
    # Inject the pre-init script before the actual init
    if [ -f "${IMAGE_ROOTFS}/sbin/${FS_INIT_PRE_INIT_NAME}" ]; then
        mv "${IMAGE_ROOTFS}/sbin/init"                      "${IMAGE_ROOTFS}/sbin/${FS_INIT_ORIGINAL_INIT_NAME}"
        mv "${IMAGE_ROOTFS}/sbin/${FS_INIT_PRE_INIT_NAME}"  "${IMAGE_ROOTFS}/sbin/init"
    fi  
}

ROOTFS_POSTPROCESS_COMMAND += "inject_pre_init; "