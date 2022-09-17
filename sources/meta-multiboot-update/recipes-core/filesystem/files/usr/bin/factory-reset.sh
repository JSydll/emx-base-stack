#!/bin/bash
# -------------------------------------------------------------------
# Executable to remove lifetime data and reach a factory state again.
# -------------------------------------------------------------------

# Clean the upper directories for mounted overlays
# ------------------------------------------------

# Default overlays
overlay-control clear-upper '/etc'

# Optional overlays
overlay-control clear-upper '/var/lib'
overlay-control clear-upper '/var/data'