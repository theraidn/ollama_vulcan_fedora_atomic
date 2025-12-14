#!/bin/bash
# Script to pull LLM models into Ollama container
# This script runs from the host terminal and executes ollama pull inside the container

set -e

# Define models to pull
MODELS=(
    "codestral:22b"
    "qwen3-coder:30b"
    "deepseek-coder-v2:16"
    "CodeGemma:latest"
)

# Container name
CONTAINER_NAME="ollama"

# Check if container is running
if ! podman ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "^$CONTAINER_NAME\$"; then
    echo "Error: Container '$CONTAINER_NAME' is not running."
    echo "Please start the container first with: podman-compose up -d"
    exit 1
fi

echo "Pulling models into $CONTAINER_NAME container..."
echo "=================================================="

# Pull each model
for model in "${MODELS[@]}"; do
    echo "📥 Pulling: $model"
    podman exec $CONTAINER_NAME ollama pull "$model"
    echo "✅ Successfully pulled: $model"
    echo ""
done

echo "=================================================="
echo "✨ All models pulled successfully!"
echo ""
echo "To list available models, run:"
echo "  podman exec $CONTAINER_NAME ollama ls"
