#!/bin/bash

# Default settings
USER_ID="$(id -u)"
XAUTH=$HOME/.Xauthority

LOCAL_CARLA_PATH="$HOME/CARLA_0.9.13"

# Check if Carla Python egg exists
if [ ! -f "${LOCAL_CARLA_PATH}/PythonAPI/carla/dist/carla-0.9.13-py3.7-linux-x86_64.egg" ]; then
    echo "Carla Python API egg file not found in ${LOCAL_CARLA_PATH}"
    exit 1
fi

DOCKER_VERSION=$(docker version --format '{{.Client.Version}}' | cut --delimiter=. --fields=1,2)
if [[ $DOCKER_VERSION < "19.03" ]]; then
    if command -v nvidia-docker &> /dev/null; then
        RUNTIME="--runtime=nvidia"
    else
        echo "Warning: nvidia-docker ist nicht installiert. Führe ohne GPU-Unterstützung aus."
        RUNTIME=""
    fi
else
    if docker info | grep -q "Runtimes: nvidia"; then
        RUNTIME="--gpus all"
    else
        echo "Warning: NVIDIA runtime not available. Running without GPU support."
        RUNTIME=""
    fi
fi

xhost +local:docker
docker run \
    -it --rm \
    --volume=$(pwd):/app/scenario_runner:rw \
    --volume=${LOCAL_CARLA_PATH}:/app/carla:rw \
    --env="DISPLAY=${DISPLAY}" \
    --env="CARLA_ROOT=/app/carla" \
    --env="PYTHONPATH=/app/scenario_runner/srunner:/app/scenario_runner:/app/carla/PythonAPI/carla/dist/carla-0.9.13-py3.7-linux-x86_64.egg:/app/carla/PythonAPI/carla:/app/carla/PythonAPI" \
    --env="XAUTHORITY=${XAUTH}" \
    --volume="${XAUTH}:${XAUTH}" \
    --privileged \
    --network="host" \
    $RUNTIME \
    scenario-runner-docker
