SUMMARY = "Provides a failsafe filesystem initialization for the system mode."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Allows the separation of software mode specific data and the adjustment of the filesystem
RPROVIDES:${PN} = "robust-filesystem-init"

FS_SOFTWARE_MODE = "system"
require robust-filesystem-init.inc