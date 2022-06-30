# --------------------------------------------------------------------------------
# Copies single slot partitions from the wic build directory to the main deploy dir
# --------------------------------------------------------------------------------
SUMMARY = "Copies single slot partitions from the wic build directory to the main deploy dir."

LICENSE = "MIT"

inherit logging

# ----------
# ATTENTION: This assumes a partition layout as defined in *-single-slot.wks.in file.
# ----------
do_copy_wic_partitions() {
    wic_workdir="${WORKDIR}/build-wic"

    bbnote "Copying single partitions from '${wic_workdir}' to IMGDEPLOYDIR..."

    image_link_base="${PN}-${MACHINE}"
    image_base="${image_link_base}-${DATETIME}"
    
    boot_part="${wic_workdir}/*.direct.p1"
    boot_part_ext="wic.boot.part"

    cp -v ${boot_part} ${IMGDEPLOYDIR}/${image_base}.${boot_part_ext}
    ln -svf ${image_base}.${boot_part_ext} "${IMGDEPLOYDIR}/${image_link_base}.${boot_part_ext}"

    rootfs_part="${wic_workdir}/*.direct.p2"
    rootfs_part_ext="wic.rootfs.part"

    cp -v ${rootfs_part} ${IMGDEPLOYDIR}/${image_base}.${rootfs_part_ext}
    ln -svf ${image_base}.${rootfs_part_ext} "${IMGDEPLOYDIR}/${image_link_base}.${rootfs_part_ext}"
}
do_copy_wic_partitions[vardepsexclude] += "DATETIME"

addtask copy_wic_partitions after do_image_wic before do_image_complete