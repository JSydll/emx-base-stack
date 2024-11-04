IMAGE_FSTYPES:append = " wic.qcow2"

# Dependencies required to populate the partitioned full image.
do_image_wic[depends] += " \
    u-boot:do_deploy \
    qemu-u-boot-files:do_deploy \
"

DEPENDS += " \
    qemu-u-boot-files \
"