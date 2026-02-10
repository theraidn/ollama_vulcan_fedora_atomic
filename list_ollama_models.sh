#!/bin/bash

# Script to list all installed LLM models in Ollama container

# Container name
CONTAINER_NAME="ollama"

# Check if container is running
if ! podman ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
    echo "Error: Container '$CONTAINER_NAME' is not running."
    echo "Please start the container first with: ./start_ollama.sh"
    exit 1
fi

echo "Checking installed models in $CONTAINER_NAME container..."
echo "======================================================="

# Execute ollama list command inside container
podman exec $CONTAINER_NAME ollama list

echo "======================================================="
echo "Model listing complete."
