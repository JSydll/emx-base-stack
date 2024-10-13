# Copyright (C) 2021 Enrico Jorns <ejo@pengutronix.de>
# Released under the MIT license (see COPYING.MIT for the terms)

# ---------------------------
# FORK of https://github.com/rauc/meta-rauc-community/blob/master/meta-rauc-qemux86/recipes-bsp/boot-image/boot-image.bb
# ---------------------------

DESCRIPTION = "Creates a boot image for qemu x86-64."

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit nopackages deploy

do_fetch[noexec] = "1"
do_patch[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot

do_deploy[depends] += "\
    dosfstools-native:do_populate_sysroot \
    mtools-native:do_populate_sysroot \
    grub-efi:do_deploy \
    rauc-grubconf:do_deploy"

do_deploy () {
    FATSOURCEDIR="${WORKDIR}/efi-boot/"
    mkdir -p ${FATSOURCEDIR}

    mkdir -p ${FATSOURCEDIR}/EFI/BOOT
    cp ${DEPLOY_DIR_IMAGE}/grub.cfg ${FATSOURCEDIR}/EFI/BOOT/
    cp ${DEPLOY_DIR_IMAGE}/grub-efi-bootx64.efi ${FATSOURCEDIR}/EFI/BOOT/bootx64.efi

    MKDOSFS_EXTRAOPTS="-S 512"
    FATIMG="${WORKDIR}/efi-boot.vfat"
    BLOCKS=32786

    rm -f ${FATIMG}

    mkdosfs -n "BOOT" ${MKDOSFS_EXTRAOPTS} -C ${FATIMG} \
                    ${BLOCKS}
    # Copy FATSOURCEDIR recursively into the image file directly
    mcopy -i ${FATIMG} -s ${FATSOURCEDIR}/* ::/
    chmod 644 ${FATIMG}

    mv ${FATIMG} ${DEPLOYDIR}/

    GRUBENV_IMG="${WORKDIR}/grubenv.vfat"

    rm -f ${GRUBENV_IMG}

    mkdosfs -n "BOOT" ${MKDOSFS_EXTRAOPTS} -C ${GRUBENV_IMG} \
                    64
    mcopy -i ${GRUBENV_IMG} -s ${DEPLOY_DIR_IMAGE}/grubenv ::/
    chmod 644 ${GRUBENV_IMG}

    mv ${GRUBENV_IMG} ${DEPLOYDIR}/
}

do_deploy[cleandirs] += "${WORKDIR}/efi-boot"

addtask deploy after do_install
