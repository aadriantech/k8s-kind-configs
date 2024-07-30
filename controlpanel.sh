#!/bin/bash

declare -A capstone_containers=(
    ["capstone-worker"]="0ea25d0c23412534359ad34dbaeab38c2016d3b7cf8d8f9e58fae9cb4d93bcce"
    ["capstone-control-plane"]="a5ab71b3046ea733f549417e36a8fc4b0420653c24bd41734d2a5703dadc9619"
    ["capstone-worker2"]="a7a8d744dce5f49671c3b64e09f1ccd78b9085e509f191c04c61ac8524228c80"
)

declare -A sandbox_containers=(
    ["sandbox-worker"]="a20c11cb07fa63d43d0dbb7b01c035906e8649b6efa671776c28776630de4164"
    ["sandbox-control-plane"]="fe987edfdab94a6c25a2761590747e9dc107c6f6f2afb8bc4a9c8bc43b719c8c"
    ["sandbox-worker2"]="20ae925560fd36ddc71b53c04c5eff18bb62508b627524989eda03abc68dccef"
)

manage_containers() {
    local action=$1
    shift
    local -n containers=$1
    for name in "${!containers[@]}"; do
        container_id=${containers[$name]}
        echo "${action^}ing container: $name (ID: $container_id)"
        docker "$action" "$container_id"
    done
}

echo "Do you want to start or shut down the clusters?"
echo "1. Start clusters"
echo "2. Shut down clusters"
read -p "Enter your choice (1/2): " action_choice

case $action_choice in
    1)
        action="start"
        ;;
    2)
        action="stop"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Which cluster do you want to $action?"
echo "1. Capstone cluster"
echo "2. Sandbox cluster"
echo "3. Both clusters"
read -p "Enter your choice (1/2/3): " cluster_choice

case $cluster_choice in
    1)
        echo "${action^}ing Capstone cluster containers..."
        manage_containers "$action" capstone_containers
        ;;
    2)
        echo "${action^}ing Sandbox cluster containers..."
        manage_containers "$action" sandbox_containers
        ;;
    3)
        echo "${action^}ing both Capstone and Sandbox cluster containers..."
        manage_containers "$action" capstone_containers
        manage_containers "$action" sandbox_containers
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Container ${action} process completed."
docker ps