# Embedded Linux Base Stack

[![Build [dunfell][raspberrypi]](https://ci.seydell.org/buildStatus/icon?job=EMX-BASE-STACK_dunfell_raspberrypi_Build)](https://ci.seydell.org/job/EMX-BASE-STACK_dunfell_raspberrypi_Build/) 

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

**Planned features**:

- Updates over various sources
  - from media device (USB)
  - via network download (ssh)
  - over-the-air (using `hawkbit` as remote backend)
- Application watchdog to determine system health
- Differential updates (using `casync`)
- Support for update bundle encryption
- Support for sub-device updates via custom hook scripts


## Getting started

To have something ready to install on one of the supported boards, you need to

**(1)** Pull the repository and checkout all submodules with

```bash
git clone https://github.com/JSydll/emx-base-stack
git submodule update --init --recursive
```

**(2)** Install the minimal host system requirements (see below).

**(3)** Configure the project as desired (by setting up a `.env` file, see below).

**(4)** Start the dockerized build environment by running

```bash
./run-env.sh --rebuild
```

_The `--rebuild` option is only required on first run as it creates the Docker_
_image used for build containers._

**(5)** Build the target image with 

```bash
bitbake full-image
```

**(6)** Locate the `*.wic` image file under `build/tmp/deploy/<machine>/` and flash it
on the device/ memory card using a tool like `Etcher`. 


### Host system requirements

The host system requirements are reduced as much as possibe, yet there are
some:

- `git` _(well, who doesn't need it...)_
- `bash`
- `Docker` (and possibly other build environment requirements, see [here](./environment/Readme.md))

For development, it is recommended to also install (and use!)

- `shellcheck`


## Branching strategy

The branches in this repo are aligned with the Yocto project releases.
Currently supported releases:

- _dunfell_


## Supported boards

The approach is to gradually expand the support on different platforms, starting with some of the widely
used development boards, such as the Raspberry Pi.

Currently supported boards:

- RaspberryPi 3 B+ _[MACHINE=raspberrypi3]_
- QEMU _[MACHINE=qemux86-64]_

For using QEMU, simply build the `full-image` (see below) and run the emulator with

```bash
./run-env.sh
runqemu full-image wic nographic ovmf slirp
```


## Configuring the project

The build system is needs to be configured using an `.env` file, as documented [in the environment docs here](./environment/Readme.md). 
Default bitbake conf templates are located under `./config`.

The board specifc integrations can be selected using the appropriate `MACHINE` configuration (see above).
For a correct configuration however, the `local.conf` must contain the `include conf/machine/${MACHINE}-extra.conf` statement.

Further required configuration parameters:
```
MACHINE               | Machine to build for.
BSP_LAYERS            | Layers containing the machine configuration and BSP packages (must be absolute paths, separated by colon).
```

See `.env.example` for a reference of the syntax.


## Building the project

To enter the build environment, simply execute `run-env.sh`. You can also forward build commands such as `bitbake -h` to this script.

For example, execute `run-env.sh "MACHINE=raspberrypi3 BSP_LAYER=meta-raspberrypi bitbake full-image"` to start a build for one of the supported boards.

**Note**: If you are on a non-release branch, be sure to start the environment with `RELEASE_TAG=<release> ./run-env.sh`.

The environment also allows you to expose additional variables to the bitbake environment using the standard Yocto way, 
via `BB_ENV_EXTRAWHITE="MYVAR1 MYVAR2"`.


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

### Common development pitfalls

**Setting up the build environment fails**

If you develop on a different branch than one of the main branches (and use `/` in your branch name),
rebuilding the Docker environment will fail unless you specify the `RELEASE_TAG` environment variable
before building.