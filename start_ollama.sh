#!/bin/bash

# Determine the absolute path to the compose file
COMPOSE_DIR="$(dirname "$0")/compose"
COMPOSE_FILE="$COMPOSE_DIR/podman-compose.yaml"

echo "Checking for existing Ollama containers and stopping/purging them..."
# Use 'down -v' to stop containers and remove volumes (like anonymous ones or if specified)
# Using || true to prevent script from exiting if no containers are running/found
podman-compose -f "$COMPOSE_FILE" down -v || true 
echo "Previous Ollama containers and volumes purged (if any)."

echo "Starting Ollama container with podman-compose..."
podman-compose -f "$COMPOSE_FILE" up -d

if [ $? -eq 0 ]; then
    echo "Ollama container started successfully in detached mode."
    echo "You can check its status with: podman ps"
    echo "Or view logs with: podman-compose -f "$COMPOSE_FILE" logs -f ollama"
else
    echo "Failed to start Ollama container."
fi