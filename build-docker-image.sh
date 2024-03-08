#!/bin/bash

# Author: David Budzynski

# Get the name of the current folder
current_folder=$(basename "$(pwd)") 

# Convert current_folder to lowercase if it contains uppercase characters
if [[ "$current_folder" =~ [A-Z] ]]; then
    current_folder=$(echo "$current_folder" | tr '[:upper:]' '[:lower:]')
fi

# Build the Docker image
docker build \
    --tag "$current_folder":latest .
