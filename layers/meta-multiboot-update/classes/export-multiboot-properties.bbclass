# Sets multiboot layout specific variables in the environment

# Note: As this is an anonymous python function, it will be executed after parsing
# but before task execution.

inherit logging

python __anonymous() {
    storage_type = d.getVar("STORAGE_TYPE")
    ptable_type = d.getVar("PTABLE_TYPE")
    enable_dual_bootloader = d.getVar("ENABLE_DUAL_BOOTLOADER")

    if not storage_type or not ptable_type:
        bb.error("Missing required parameters!")

    bb.debug(2, "Setting multiboot properties (%s, %s, dual bootloader: %s)..." % (storage_type, ptable_type, enable_dual_bootloader))

    # Determine the slot layout
    device = ""
    if "mmc" in storage_type:
        device = "/dev/" + d.getVar("MMC_BLOCK_DEVICE") + "p"
    elif "sda" in storage_type:
        device = "/dev/sda"
    else:
        bb.error("Unsupported (yet) storage type: %s!" % storage_type)

    part_offset = 2 if not enable_dual_bootloader else 3
    def get_part_number(base):
        if ptable_type == "msdos" and base > 3:
            return str(base + 1)
        return str(base)
    
    part_num = get_part_number(part_offset)
    d.setVar("RECOVERY_BOOT_PART", part_num)
    d.setVar("RECOVERY_BOOT_DEVICE", device + part_num)

    part_num = get_part_number(part_offset + 1)
    d.setVar("RECOVERY_ROOTFS_PART", part_num)
    d.setVar("RECOVERY_ROOTFS_DEVICE", device + part_num)

    part_num = get_part_number(part_offset + 2)
    d.setVar("SYSTEM_BOOT_PART", part_num)
    d.setVar("SYSTEM_BOOT_DEVICE", device + part_num)
    
    part_num = get_part_number(part_offset + 3)
    d.setVar("SYSTEM_ROOTFS_PART", part_num)
    d.setVar("SYSTEM_ROOTFS_DEVICE", device + part_num)
}