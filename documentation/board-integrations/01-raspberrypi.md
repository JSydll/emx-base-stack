# Integrating multiboot and software update on the Raspberry Pi

There are a number of specialities of the Raspberry Pi hardware and the BSP provided 
in the community `meta-raspberrypi` that create challenges for the multiboot integration.
First and foremost, the Pi requires the one-and-only boot media to comply to a certain
layout and offers rather limited possibilities to freely define the boot sequence.

> Learning: The boot requirements of the target platform need to be known.


## Boot sequence

The official boot sequence of the Raspberry Pi are 
[documented on raspberrypi.com](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#boot-sequence).

Simplified, there is a burned-in first stage bootloader (in ROM) is executed by the **GPU**
which searches for the second stage bootloader (`bootcode.bin`). This loads the GPU firmware (`start.elf`)
capable of reading some system configuration from the `config.txt` file. Finally, the third stage
bootloader is loaded and executed by the **CPU**. This is either a Linux kernel identified by name
(`kernel.img`) or, if configured in the txt file, another bootloader stage such as `u-boot`.

### Dealing with bootloader failures

The Raspberry Pi will fail to boot if any errors occur throughout the above sequence. The ACT led might
give some insights on the type of failure:

- 3 flashes: `start.elf` not found
- 4 flashes: `start.elf` not launch-able (corrupt)
- 7 flashes: `kernel.img` / third-stage bootloader not found
- 8 flashes: SDRAM not recognized. A newer bootcode.bin/start.elf firmware is needed, or the SDRAM is damaged

### Bootloader files location

For the Raspberry Pi 3 and before, the aforementioned artifacts are searched in a FAT
partition on the SD card. The Pi 4 adds more flexibility as it comes with a programmable EEPROM.

By default, the `meta-raspberrypi` BSP puts the bootloader in the same partition as the
kernel, but this prevents updating the kernel while leaving the bootloader untouched.

That's why the kernel and bootloader files shall be separated.


## Separating kernel and bootloader files

The recipes in `meta-raspberrypi` collect all boot files and reference them in `IMAGE_BOOT_FILES`.
This variable can be used by the `bootimg-partition` wic plugin to create a bootable first partition.
As the plugin is a convenient way to deploy all necessary files, it can be used for the kernel and
DTB files - given the bootloader-related files are removed fom the variable.

In theory, the `bootimg-partition` plugin has a mechanism to allow differentiating between
partition-specific files by using a `IMAGE_BOOT_FILES_label-<label>` syntax, but as of today,
this does not work due to a [known issue](https://lists.yoctoproject.org/g/yocto/message/54800).

As a reusable alternate solution, a custom wic source plugin can be implemented that allows installing
files from an archive file into a partition created and prepared by wic. See `rpi-bootloader-files.bb`
and the plugin under `poky-extensions/scripts/lib/wic/plugins/source/extract-from-archive.py` for details.

Sidenote: An attempt to create a custom image type that creates an in-file vfat partition image for the
bootloader files failed due to conflicts of the information wic puts into the partition table header
and the properties of the image file.

> Learning: Be cautious of filesystem properties put in the partition table header by wic.