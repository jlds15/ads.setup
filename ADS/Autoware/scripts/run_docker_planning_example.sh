#!/usr/bin/env sh

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

. "$SCRIPT_DIR/utils.sh"

docker compose run --rm \
    --name autoware-oci \
    autoware -- \
    sh -c 'ros2 launch autoware_launch planning_simulator.launch.xml map_path:=$DIR_MAPS_TARGET/sample-map-planning vehicle_model:=sample_vehicle sensor_model:=sample_sensor_kit'
