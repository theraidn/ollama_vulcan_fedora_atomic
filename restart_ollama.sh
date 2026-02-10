#!/bin/bash

# Define the container name
CONTAINER_NAME="ollama"

# Stop the existing Ollama container if it's running
if podman ps -a --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
    echo "Stopping $CONTAINER_NAME..."
    podman stop "$CONTAINER_NAME"
fi

# Remove the stopped container
if podman ps -a --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
    echo "Removing $CONTAINER_NAME..."
    podman rm "$CONTAINER_NAME"
fi

# Start a new Ollama container using the compose file
echo "Starting $CONTAINER_NAME..."
podman-compose -f compose/podman-compose.yaml up -d