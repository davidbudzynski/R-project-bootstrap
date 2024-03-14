#!/usr/bin/env bash
# Author: David Budzynski

# This script runs a Docker container using the built image. It mounts the
# current working directory into the container and sets the working directory to
# the mounted directory. The container is run in interactive and tty mode,
# allowing for user interaction. Once the container finishes running, it is
# automatically removed (--rm flag).

docker run --rm \
    --interactive \
    --tty \
    --volume $(pwd):/home/$(basename "$(pwd)")/ \
    --workdir /home/$(basename "$(pwd)")/ \
    # change the image name to the one you built i.e. lowercase name of the
    # current folder
    r-project-bootstrap:latest
