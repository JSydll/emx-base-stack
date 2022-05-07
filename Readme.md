# Reference implementation for embedded Linux systems

This repository aims to provide a reference implementation for updateable, secure embedded Linux systems
that are built with the Yocto build system.

**Current features**:

- Basic stack structure

**Planned features**:

- Multiboot (A/B update schema) 
- Differential updates (using `casync`) over various sources
  - from media device (USB)
  - via network download (ssh)
  - over-the-air (using `hawkbit` as remote backend)
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

- RaspberryPi 3 B+ _[MACHINE=raspberrypi3-mb]


## Configuring the project

The build system is needs to be configured using an `.env` file, as documented [in the environment docs here](./environment/Readme.md). 
A reference for the templates can be found under `./config`.

The board specifc integrations can be selected using the apropriate `MACHINE` configuration (see above).


## Building the project

To enter the build environment, simply execute `run-env.sh`. You can also forward build commands such as `bitbake -h` to this script.

The environment allows you to expose additional variables to the bitbake environment using the standard Yocto way, 
via `BB_ENV_EXTRAWHITE="MYVAR1 MYVAR2"`.