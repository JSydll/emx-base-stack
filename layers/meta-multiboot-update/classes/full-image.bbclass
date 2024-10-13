# --------------------------------------------------------------------------------
# Reusable class to create a full image containing recovery and system sub-images.
# --------------------------------------------------------------------------------
SUMMARY = "Reusable class to create a full image / rootfs."

LICENSE = "MIT"

# Define an empty image as the contents of the multiboot image shall be 
# taken from distinct image recipes.

IMAGE_FEATURES = ""
IMAGE_INSTALL = ""
PACKAGE_INSTALL = ""

inherit image
inherit logging

RECOVERY_IMAGE_NAME ?= "recovery-image"
SYSTEM_IMAGE_NAME ?= "system-image"

require board-definitions/${MACHINE}.inc

WKS_FILE = "multiboot.wks.in"
IMAGE_FSTYPES = "wic.bz2 wic.bmap"

DEPENDS += " \
    ${RECOVERY_IMAGE_NAME} \
    ${SYSTEM_IMAGE_NAME} \
"

# Enforce the images of the respective modes complete before building the integrated image.
do_rootfs[depends] += " \
    ${RECOVERY_IMAGE_NAME}:do_image_complete \
    ${SYSTEM_IMAGE_NAME}:do_image_complete \
"

# Make sure to clean partial images when cleaning the full image.
do_clean[depends] += " \
    ${RECOVERY_IMAGE_NAME}:do_clean \
    ${SYSTEM_IMAGE_NAME}:do_clean \
"

# ----------------------------------------------------
# Deployment of artifacts to be used in update bundles
# ----------------------------------------------------

inherit export-multiboot-properties

do_deploy_wic_artifacts() {
    wic_workdir="${WORKDIR}/build-wic"
    image_link_base="${PN}-${MACHINE}"
    image_base="${image_link_base}-${DATETIME}"

    bbnote "Copying partitions from '${wic_workdir}' to IMGDEPLOYDIR..."
    
    ext="wic.recovery.boot.vfat"
    cp -v "${wic_workdir}"/*.direct.p"${RECOVERY_BOOT_PART}" "${IMGDEPLOYDIR}"/"${image_base}.${ext}"
    ln -svf "${image_base}.${ext}" "${IMGDEPLOYDIR}"/"${image_link_base}.${ext}"

    ext="wic.recovery.rootfs.img"
    cp -v "${wic_workdir}"/*.direct.p"${RECOVERY_ROOTFS_PART}" "${IMGDEPLOYDIR}"/"${image_base}.${ext}"
    ln -svf "${image_base}.${ext}" "${IMGDEPLOYDIR}"/"${image_link_base}.${ext}"

    ext="wic.system.boot.vfat"
    cp -v "${wic_workdir}"/*.direct.p"${SYSTEM_BOOT_PART}" "${IMGDEPLOYDIR}"/"${image_base}.${ext}"
    ln -svf "${image_base}.${ext}" "${IMGDEPLOYDIR}"/"${image_link_base}.${ext}"

    ext="wic.system.rootfs.ext4"
    cp -v "${wic_workdir}"/*.direct.p"${SYSTEM_ROOTFS_PART}" "${IMGDEPLOYDIR}"/"${image_base}.${ext}"
    ln -svf "${image_base}.${ext}" "${IMGDEPLOYDIR}"/"${image_link_base}.${ext}"
}
do_deploy_wic_artifacts[vardepsexclude] += "DATETIME"

addtask deploy_wic_artifacts after do_image_wic before do_image_complete