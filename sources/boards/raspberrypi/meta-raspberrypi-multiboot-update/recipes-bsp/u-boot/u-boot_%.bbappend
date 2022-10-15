FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI_rpi:append = " \
    file://fw_env.config \
"