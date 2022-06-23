# Reference implementation for embedded Linux systems

This repository aims to provide a reference implementation for updateable, secure embedded Linux systems
that are built with the Yocto build system.

**Current features**:

- Basic stack structure
- Dual boot (recovery/system update schema) _[for RaspberryPi 3]_

**Planned features**:

- Differential updates (using `casync`) over various sources
  - from media device (USB)
  - via network download (ssh)
  - over-the-air (using `hawkbit` as remote backend)
- Bootcounter support
- Application watchdog to determine system health
- Authentication of updates via certificates
- Support for update bundle encryption
- Support for sub-device updates via custom hook scripts


## Branching strategy

The branches in this repo are aligned with the Yocto project releases.
Currently supported releases:

- _dunfell_


## Supported boards

The approach is to gradually expand the support on different platforms, starting with some of the widely
used development boards, such as the Raspberry Pi.

Currently supported boards:

- RaspberryPi 3 B+ _[MACHINE=raspberrypi3]_


## Configuring the project

The build system is needs to be configured using an `.env` file, as documented [in the environment docs here](./environment/Readme.md). 
Default bitbake conf templates are located under `./config`.

The board specifc integrations can be selected using the appropriate `MACHINE` configuration (see above).
For a correct configuration however, the `local.conf` must contain the `include conf/machine/${MACHINE}-extra.conf` statement.

Further required configuration parameters:
```
MACHINE               | Machine to build for.
BSP_LAYER             | Layer containing the machine configuration and BSP packages.
BSP_EXTENSION_LAYER   | Layer containing extension necessary to support multiboot update on the given BSP
STORAGE_TYPE          | Type of persistent storage (available options: [mmc], default: 'mmc').
MMC_BLOCK_DEVICE      | Allows specification of a custom eMMC block device (default: '/dev/mmcblk0') - only evaluated if STORAGE_TYPE is 'mmc'.
```

See `.env.example` for a reference of the syntax.


## Building the project

To enter the build environment, simply execute `run-env.sh`. You can also forward build commands such as `bitbake -h` to this script.

For example, execute `run-env.sh "MACHINE=raspberrypi3 BSP_LAYER=meta-raspberrypi bitbake full-image"` to start a build for one of the supported boards.

The environment also allows you to expose additional variables to the bitbake environment using the standard Yocto way, 
via `BB_ENV_EXTRAWHITE="MYVAR1 MYVAR2"`.