# Integrating multiboot and software update on the Raspberry Pi

There are a number of specialities of the Raspberry Pi hardware and the BSP provided 
in the community `meta-raspberrypi` that create challenges for the multiboot integration.
First and foremost, the Pi requires the one-and-only boot media to comply to a certain
layout and offers rather limited possibilities to freely define the boot sequence.

> Learning: The boot requirements of the target platform need to be known.


## Boot sequence

The official boot sequence of the Raspberry Pi are [documented on raspberrypi.com](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#boot-sequence).

Simplified, there is a burned-in first stage bootloader (in ROM) which searches for the
second stage bootloader (e.g. u-boot) in a fixed sequence. Afterwards, the Linux kernel
is loaded.

For the Raspberry Pi 3 and before, the corresponding artifacts are searched in a FAT
partition on the SD card. The Pi 4 adds more flexibility as it comes with a programmable EEPROM.

By default, the `meta-raspberrypi` BSP puts the bootloader in the same partition as the
kernel, but this prevents updating the kernel while leaving the bootloader untouched.

That's why a separate bootloader image shall be created.

## Adjusted bootloader image

To allow for proper dependency definitions between the distinct partial images and the
full system image, the separate bootloader image can be created by defining a distinct
image type. This is similar to the old approach to create SD card images (see
`sdcard_image-rpi.bbclass` for reference) - while `wic` is the modern way to define
multi-partition images, the `bbclass` makes good use of existing functionalities provided
by poky.