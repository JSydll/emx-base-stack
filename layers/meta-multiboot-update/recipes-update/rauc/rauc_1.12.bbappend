RDEPENDS:${PN} += " \
    ${@bb.utils.contains('PREFERRED_PROVIDER_virtual/bootloader', 'u-boot', 'u-boot-fw-utils u-boot-default-env', '', d)} \
"