#!/usr/bin/env bash

# Author: David Budzynski

# This script runs a Docker image named "proj-setup" with the following
# configurations:
# - The "--rm" flag removes the container after it exits.
# - The "--interactive" and "--tty" flags allocate a pseudo-TTY and keep STDIN
#   open even if not attached.
# - The "--env DISABLE_AUTH=true" flag sets the environment variable
#   "DISABLE_AUTH" to "true".
# - The "--publish 127.0.0.1:8787:8787" flag publishes port 8787 on the host to
#   port 8787 on the container.
# - The "--volume $(pwd):/home/rstudio/" flag mounts the current working
#   directory on the host to "/home/rstudio/" in the container.
# - The "--workdir /home/rstudio/" flag sets the working directory inside the
#   container to "/home/rstudio/".
# - The "proj-setup" argument specifies the name of the Docker image to run.

docker run --rm \
    --interactive \
    --tty \
    --env DISABLE_AUTH=true \
    --publish 127.0.0.1:8787:8787 \
    --volume $(pwd):/home/rstudio/ \
    --workdir /home/rstudio/ \
    proj-setup
