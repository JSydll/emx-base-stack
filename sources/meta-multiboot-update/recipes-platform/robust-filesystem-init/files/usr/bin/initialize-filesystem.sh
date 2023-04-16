#!/bin/bash -e
#
# Sets up the required filesystem structure for overlays and shared data
#

mkdir -p /var/persistent/shared/overlays/ssh /var/persistent/shared/overlays/ssh-work

mkdir -p /var/persistent/shared/media
mkdir -p /var/persistent/private/log