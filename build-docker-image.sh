#!/bin/bash

# Author: David Budzynski

# Load environment variables from .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if SSH_PRIVATE_KEY_PATH variable is set
if [ -z "$SSH_PRIVATE_KEY_PATH" ]; then
    echo "Error: SSH_PRIVATE_KEY_PATH is not set."
    exit 1
fi

# Check if the SSH private key file exists
if [ ! -f "$SSH_PRIVATE_KEY_PATH" ]; then
    echo "Error: SSH private key file '$SSH_PRIVATE_KEY_PATH' not found."
    exit 1
fi

# Read the SSH private key from the file
SSH_PRIVATE_KEY_CONTENT=$(cat "$SSH_PRIVATE_KEY_PATH")

# Check if GIT_USER_NAME and GIT_USER_EMAIL variables are set
if [ -z "$GIT_USER_NAME" ]; then
    echo "Error: GIT_USER_NAME is not set."
    exit 1
fi

if [ -z "$GIT_USER_EMAIL" ]; then
    echo "Error: GIT_USER_EMAIL is not set."
    exit 1
fi

# Get the name of the current folder
current_folder=$(basename "$(pwd)")

# Build the Docker image
docker build \
    --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY_CONTENT" \
    --build-arg GIT_USER_NAME="$GIT_USER_NAME" \
    --build-arg GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    --tag "$current_folder":latest .
