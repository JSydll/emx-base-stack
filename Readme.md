# Embedded Linux Base Stack

[![Build [kirkstone|raspberrypi]](https://ci.seydell.org/buildStatus/icon?job=emx-base-stack_kirkstone_raspberrypi3&subject=kirkstone/raspberrypi3)](https://ci.seydell.org/job/emx-base-stack_kirkstone_raspberrypi3/)

This repository aims to provide a reference implementation for updateable, secure embedded Linux systems
that are built with the Yocto build system.

**Current features**:

- Basic stack structure
- Dual boot (recovery/system update schema)
- Bootcounter support
- Creation of update bundles
- Authentication of updates via certificates
- Some common configurations (like root password, ssh config, etc)
- Lightweight factory reset (through overlay clearance)
- Updates over various sources
  - from media device (USB)
  - via network download (ssh)
  - over-the-air (using `hawkbit` as remote backend, see [backend](./backend/Readme.md))

**Planned features**:

- Application watchdog to determine system health
- Differential updates (using `casync`)
- Support for update bundle encryption
- Support for sub-device updates via custom hook scripts


## Getting started

To have something ready to install on one of the supported boards, you need to

**(1)** Install the minimal host system requirements (see below).

**(2)** Pull the repository

```bash
git clone https://github.com/JSydll/emx-base-stack
```

**(3)** Optional: Provide custom configure for some features (e.g. by setting up a `.env` file, see below).

**(4)** Start the build by running

```bash
./run-kas build conf/<machine>.yml <image [default: full-image]>
```

**(5)** Locate the `*.wic` image file under `build/tmp/deploy/<machine>/` and flash it
on the device/ memory card using a tool like `Etcher`. 


### Host system requirements

The host system requirements are reduced as much as possible, yet there are
some:

- `git` _(well, who doesn't need it...)_
- `bash`
- `Docker`

For development, it is recommended to also install (and use!)

- `shellcheck`

If you want to run the `hawkbit` Update Backend Server, you'll also need

- `docker-compose`


## Branching strategy

The branches in this repo are aligned with the Yocto project releases.

Currently supported releases:
- _kirkstone_

No longer maintained releases:
- _dunfell_ (no further feature development)

Note: You have to checkout the corresponding branch as the build environment and features
can significantly differ.


## Supported machines and images

The approach is to gradually expand the support on different platforms, starting with some of the widely
used development boards, such as the Raspberry Pi.

Currently supported boards:

- RaspberryPi 3 B+ _[MACHINE=raspberrypi3]_
- QEMU _[MACHINE=qemux86-64]_

For these, the following images can be built:

  - full-image              - Builds the full image (including recovery & system) with the configured sub-images.
  - system-update-bundle    - Builds a system update bundle with the configured sub-image.
  - recovery-update-bundle  - Builds a recovery update bundle with the configured sub-image.

  - custom-recovery-image   - Builds the recovery image only, with custom applications included.
  - custom-system-image     - Builds the system image only, with custom applications included.

For using QEMU, simply build the `full-image` and run the emulator with

```bash
./run-kas shell 
runqemu full-image wic nographic ovmf slirp
```


## Configuring the project

The overall configuration is managed via the [kas](https://github.com/siemens/kas) tool.
It's main configuration can be found under [`./conf`](./conf).

Besides, the customizable features can be configured using an `.env` file. See `.env.example` for a reference of the syntax.

The board specifc integrations can be selected using the appropriate `MACHINE` name in the `run` commands (see above).


## Building the project

Like the configuration, the build environment is provided by [kas](https://github.com/siemens/kas).
The `./run-kas` script provided in this repo is only a shallow wrapper around the scripts copied from upstream kas, 
currently at version 4.5, like recommended by the respective documentation.

If you want to stay in the bitbake environment (and not only execute a single build command), you can use
```bash
./run-kas shell <machine>
```


## Deploying build artifacts

There are two types of build artifacts: _full system images_ and _update bundles_.

**Full system images** contain a fully partitioned representation of the system to be installed
on the main memory (e.g. the eMMC).
Depending on the hardware, this might require specific tools provided by the board manufacturer.
In the case of popular single-board-computers like the RaspberryPi, the external SD card needs
to be flashed with the image - which is most easily done with a tool like
[Etcher](https://www.balena.io/etcher/).

As soon as the device is initially flashed with the expected partitioning and software,
**update bundles** can be installed by bringing them on the device and simply running

```bash
sw-mode-control update /path/to/update-bundle.raucb
```

Of course, this will only work for bundles to update the currently inactive software mode
(i.e. the `system` mode needs to be running to update the `recovery` software and vice versa).
To switch modes, you can use

```bash
sw-mode-control start-system|start-recovery
```


## Contribution

Feel free to contact me in case you have feature proposals or want to contribute.