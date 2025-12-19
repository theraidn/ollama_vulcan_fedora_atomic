#!/bin/bash

echo "Stopping Ollama container with podman-compose..."
podman-compose -f "$(dirname "$0")/compose/podman-compose.yaml" down

if [ $? -eq 0 ]; then
    echo "Ollama container stopped successfully."
    echo "You can verify with: podman ps"
else
    echo "Failed to stop Ollama container. It might not have been running."
fi
