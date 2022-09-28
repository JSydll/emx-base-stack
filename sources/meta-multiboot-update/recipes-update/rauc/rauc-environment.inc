# Export the environment variables processed in the system.conf template

inherit logging
inherit export-multiboot-properties

python __anonymous() {
    storage_type = d.getVar("STORAGE_TYPE")
    ptable_type = d.getVar("PTABLE_TYPE")
    bootloader = d.getVar("PREFERRED_PROVIDER_virtual/bootloader")
    enable_dual_bootloader = d.getVar("ENABLE_DUAL_BOOTLOADER")

    if not storage_type or not bootloader or not ptable_type:
        bb.error("Missing required parameters!")

    bb.debug(2, "Setting bootloader properties (%s, %s, dual bootloader: %s)..." % (bootloader, ptable_type, enable_dual_bootloader))

    device = ""
    if "mmc" in storage_type:
        device = "/dev/" + d.getVar("MMC_BLOCK_DEVICE") + "p"
    elif "sda" in storage_type:
        device = "/dev/sda"
    else:
        bb.error("Unsupported (yet) storage type: %s!" % storage_type)

    d.setVar("EXTRA_BOOTLOADER_OPTIONS", "")
    d.setVar("BOOTLOADER_SLOT_CONF", "")
    # Determine bootloader configuration
    if "u-boot" in bootloader:
        d.setVar("BOOTLOADER", "uboot")

    elif "grub" in bootloader:
        d.setVar("BOOTLOADER", "grub")
        d.setVar("EXTRA_BOOTLOADER_OPTIONS", "grubenv=/grubenv/grubenv")
        if enable_dual_bootloader:
            if ptable_type == "gpt":
                # Note: This assumes a fixed layout of 2x 40M for the bootloader slots.
                d.setVar("BOOTLOADER_SLOT_CONF",
                        "[slot.bootloader.0]\n"
                        "device=" + device + "1\n"
                        "type=boot-gpt-switch\n"
                        "region-start=4M\n"
                        "region-size=80M")
}