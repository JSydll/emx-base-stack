# Multiboot update reference implementation

[WIP]

Current implementation is shamelessly copied from https://github.com/rauc/meta-rauc-community/tree/master/meta-rauc-raspberrypi. 
But it needs many adjustments to be aligned with the approaches below.

----

## Software update concepts

Nowadays, the ability to update an embedded system is a hygiene factor for the product consisting of it -
either for fixing bugs discovered in the field or to extend the system's software with additional features.

There are several great introductions (for example [here](https://www.pengutronix.de/de/blog/2019-08-16-rauc_maintenance.html), 
[here](https://mkrak.org/2018/01/10/updating-embedded-linux-devices-part1/) or [here](https://sbabic.github.io/swupdate/scenarios.html)) 
into the considerations to be made for implementing a robust, secure software update mechanism, hence no detailed
explanations are given here.

As it represents a very reliable approach as well as one of the more complex scenarios, this reference employs
a **image-base single copy/dual rescue** approach. In this setup, there will always be a working sub-system capable of
updating the rest of the system and only complete system images will be written. The latter ensures a consistent/known
state of the system.


## Choosing an update framework

It is a good idea, not to reinvent the update-wheel. There is a [comprehensive overview](https://wiki.yoctoproject.org/wiki/System_Update) 
of existing device-side solutions.

For embedded Linux systems based on Yocto, there are de facto two standard frameworks:

- [SWUpdate](https://sbabic.github.io/swupdate/swupdate.html)
- [RAUC](https://www.rauc.io/)

This reference is based on the RAUC framework as it was proven to be relatively easy to integrate and to extend.


## System overview

To allow for the image-based updates a specific partitioning scheme needs to be employed:

```
bootloader      | raw       |
recov_a/boot    | vfat      |
recov_a/fs      | squashfs  | ro
recov_b/boot    | vfat      |
recov_b/fs      | squashfs  | ro
sys/boot        | vfat      |
sys/fs          | squashfs  | ro
app/fs          | ext4      | rw
```


## Key integration activities

For each hardware target, a similar set of integration activities needs to be undertaken:

**On BSP level**:
- _Implement multiboot support_
  - _Boot command with slot selection_ (according to partition layout)
  - _Bootcounter for system health detection_

**On project level**:
- _Complete multiboot integration_
  - _Implement extended partition scheme_
  - _Setup image creation_ (using wic)
- _Configure update package creation_ (by completing `meta-rauc` integration and using post-update hook scripts)
- _Configure update source selection_
- _Setup of overlays (partitions & squashfs) & base files_
- _Test end-to-end Software Update process_

