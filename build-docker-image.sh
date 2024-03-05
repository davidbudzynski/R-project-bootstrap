#!/usr/bin/env bash

# Author: David Budzynski

# This script builds a Docker image for the current project folder.

# Get the name of the current folder
current_folder=$(basename "$(pwd)")

# Build the Docker image with the current folder name as the tag
docker build --tag "$current_folder":latest .