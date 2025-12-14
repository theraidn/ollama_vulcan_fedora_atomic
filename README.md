# Ollama with Vulkan GPU Acceleration via Podman Compose

This repository provides a `podman-compose` configuration to run Ollama with Vulkan GPU acceleration, specifically tailored for Fedora Atomic Workstations (like Fedora Kinoite). It enables you to easily deploy and manage Ollama for local LLM inference, leveraging your system's Vulkan-compatible GPU.

## Features

*   **Vulkan GPU Acceleration**: Leverages your AMD or Intel GPU's Vulkan capabilities for faster LLM inference.
*   **Podman Compose**: Uses `podman-compose` for straightforward container orchestration.
*   **Data Persistence**: Ollama models and data are stored persistently on your host system via a bind mount.
*   **Configurable**: Easily adjust container behavior (restart policy, user, data path, container name) using a `.env` file.
*   **Simple Management Scripts**: `start_ollama.sh` and `stop_ollama.sh` for convenient container lifecycle management.
*   **Optimized for Fedora Atomic Workstations**: Includes necessary configurations like SELinux relabeling (`:Z`) for host volume mounts.

## Prerequisites

*   **Podman**: Ensure Podman is installed and configured on your Fedora Atomic Workstation.
*   **podman-compose**: Install `podman-compose` (often available via `pip install podman-compose`).
*   **Vulkan Drivers**: Your host system must have up-to-date Vulkan-compatible GPU drivers installed and configured for your AMD or Intel GPU.

## Getting Started

1.  **Navigate to the Project Root**:
    ```bash
    cd /path/to/your/ollama-vulkan-podman-project --> Adjust to your actual path
    ```

2.  **Configure Environment Variables**:
    Edit the `.env` file located in the `compose/` directory to customize your setup.
    ```bash
    nano compose/.env --> or your preferred text editor
    ```
    **Example `compose/.env` content:**
    ```dotenv
    # This file contains environment variables for the podman-compose setup.
    # You can override these defaults by uncommenting and modifying the lines below,
    # or by setting these environment variables in your shell before running podman-compose.

    # Container restart policy. Options: "no", "on-failure", "always", "unless-stopped".
    # RESTART_POLICY=unless-stopped

    # User ID (UID) and Group ID (GID) for the Ollama container process.
    # This should typically match your host user's UID and GID to ensure proper
    # permissions for the mounted volume.
    # You can find your UID and GID by running 'id -u' and 'id -g' in your terminal.
    # UID=1000
    # GID=1000

    # Absolute path on the host system where Ollama will store its models and data.
    # OLLAMA_DATA_PATH=/path/to/your/ollama_data
    # Name of the Ollama container.
    # CONTAINER_NAME=ollama-vulkan
    ```
    **Important**: Ensure `UID` and `GID` match your host user's IDs if you encounter permission errors.

3.  **Make Scripts Executable**:
    ```bash
    chmod +x start_ollama.sh stop_ollama.sh
    ```

4.  **Start Ollama**:
    This script will stop and purge any previous Ollama containers, then start a new one in detached mode.
    ```bash
    ./start_ollama.sh
    ```
    You can check the container's status with `podman ps` or view its logs with `podman-compose -f compose/podman-compose.yaml logs -f ollama`.

5.  **Interact with Ollama**:
    Once started, you can pull and run models:
    ```bash
    ollama pull llama2 # If you have the Ollama CLI installed on your host
    ```
    Or, execute commands directly inside the container:
    ```bash
    podman exec -it ollama-vulkan ollama pull llama2
    ```
    Verify models are present on your host in the `OLLAMA_DATA_PATH` directory (e.g., `/home/ben/.ollama`).

6.  **Stop Ollama**:
    ```bash
    ./stop_ollama.sh
    ```

## Troubleshooting

*   **`Error: mkdir /opt/ollama/blobs: permission denied`**:
    This often indicates SELinux or file permission issues. The configuration includes the `:Z` flag on the volume mount and runs Ollama as your user (`UID:GID`) to mitigate this. Ensure your host `OLLAMA_DATA_PATH` (e.g., `/home/ben/.ollama`) is owned by your user (`chown $USER:$USER /home/ben/.ollama`) and has appropriate write permissions.
*   **`Error: ... address already in use`**:
    Another process on your host is using port `11434`. Ensure no other Ollama instance or service is running. The `start_ollama.sh` script attempts to stop/purge old containers, but manual intervention might be needed (`podman ps -a`, `podman stop <ID>`, `podman rm <ID>`).
*   **Vulkan Issues**: Ensure your host system has the correct and up-to-date Vulkan drivers for your GPU. Verify Vulkan is working on your host system with tools like `vulkaninfo`.
*   **Container Stops Immediately**: Check `podman-compose -f compose/podman-compose.yaml logs ollama` for more detailed error messages.


