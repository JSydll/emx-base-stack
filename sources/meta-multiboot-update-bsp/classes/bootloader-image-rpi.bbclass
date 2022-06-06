inherit image_types
#
# Create a bootloader-only image artifact
# --------------
#
# The meta-raspberrypi BSP layer assumes that the bootloader is in the same (vfat) partition 
# as the kernel and device tree files. However, this is not desired for the multiboot pertition
# scheme as the kernel artifacts shall be updateable (but the bootloader not).
#
# To separate the bootloader files from the kernel related ones, a separate vfat image that only 
# contains the bootloader is built as an artifact. This can then be installed into a dedicateed
# partition. To have the rest of the files end up in the kernel partition, the bootloader files 
# are removed from the IMAGE_BOOT_FILES variable so that the partition can be created as usual 
# using wic's bootimg-partition plugin.

inherit logging

# Constants taken from sdcard_image-rpi.bbclass and rpi-base.inc
RPI_BOOTLOADER_SPACE ?= "25600"
RPI_FILESYSTEM_ALIGNMENT = "4096"

RPI_BOOTLOADER_FILES = "${BOOTFILES_DIR_NAME}/* u-boot.bin boot.scr"
RPI_BOOTLOADER_IMG = "${IMAGE_NAME}.vfat"
RPI_BOOTLOADER_LINK_IMG = "${IMAGE_LINK_NAME}.vfat"

# Tool and task dependencies for bootloader image creation
do_image_bootloader_image_rpi[depends] = " \
    mtools-native:do_populate_sysroot \
    dosfstools-native:do_populate_sysroot \
    ${IMAGE_BOOTLOADER}:do_deploy \
    rpi-config:do_deploy \
    u-boot:do_deploy \
    u-boot-default-script:do_deploy \
"
do_image_bootloader_image_rpi[recrdeps] = "do_build"

# Creates the raspberrypi3 specific vfat image before starting to assemble the multiboot image
IMAGE_CMD_bootloader-image-rpi() {
    img_file="${WORKDIR}/bootloader.vfat"

    # Calculate aligned size and boot blocks
    aligned_size=$(expr ${RPI_BOOTLOADER_SPACE} + ${RPI_FILESYSTEM_ALIGNMENT} - 1)
    aligned_size=$(expr ${aligned_size} - ${aligned_size} % ${RPI_FILESYSTEM_ALIGNMENT})
    boot_blocks=$(expr ${aligned_size} \+ ${RPI_FILESYSTEM_ALIGNMENT})
    
    # Create a vfat image file for the boot files
    if [ -e ${img_file} ]; then 
        rm -f ${img_file}
    fi
    mkfs.vfat -F32 -S 512 -C ${img_file} ${boot_blocks}

    # Deploy the boot artifacts to the vfat image
    mcopy -v -i ${img_file} -s ${DEPLOY_DIR_IMAGE}/${BOOTFILES_DIR_NAME}/* ::/ \
        || bbfatal "mcopy cannot copy ${DEPLOY_DIR_IMAGE}/${BOOTFILES_DIR_NAME}/* into bootloader image!"
    # Note: Requires explicit setting of kernel=u-boot in config.txt
    mcopy -v -i ${img_file} -s ${DEPLOY_DIR_IMAGE}/u-boot.bin  ::/ \
        || bbfatal "mcopy cannot copy ${DEPLOY_DIR_IMAGE}/u-boot.bin into bootloader image!"
    mcopy -v -i ${img_file} -s ${DEPLOY_DIR_IMAGE}/boot.scr    ::/ \
        || bbfatal "mcopy cannot copy ${DEPLOY_DIR_IMAGE}/boot.scr into bootloader image!" 

    # Add stamp file
    echo "${IMAGE_NAME}" > ${WORKDIR}/image-version-info
    mcopy -v -i ${img_file} ${WORKDIR}/image-version-info  ::/ \
        || bbfatal "mcopy cannot copy ${WORKDIR}/image-version-info into bootloader image!"

    # Deploy the vfat image
    cp -v ${img_file} ${IMGDEPLOYDIR}/${RPI_BOOTLOADER_IMG}
    ln -svf ${RPI_BOOTLOADER_IMG} "${IMGDEPLOYDIR}/${RPI_BOOTLOADER_LINK_IMG}"
}

# Remove bootloader from IMAGE_BOOT_FILES as this will be used to create the kernel partitions
IMAGE_BOOT_FILES_remove = "${RPI_BOOTLOADER_FILES}" 