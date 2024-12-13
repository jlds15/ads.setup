#!/usr/bin/env sh

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

. "$SCRIPT_DIR/utils.sh"

docker compose run --rm \
    --name autoware-oci \
    autoware -- \
    ros2 launch autoware_launch planning_simulator.launch.xml map_path:=/data/maps/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit
