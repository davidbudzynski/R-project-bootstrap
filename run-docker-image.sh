#!/usr/bin/env bash

# Author: David Budzynski

docker run --rm \
    --interactive \
    --tty \
    --volume $(pwd):/home/$(basename "$(pwd)")/ \
    --workdir /home/$(basename "$(pwd)")/ \
    r-project-bootstrap:latest
