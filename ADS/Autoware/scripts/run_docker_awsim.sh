#!/usr/bin/env sh

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

. "$SCRIPT_DIR/utils.sh"

docker compose run --rm \
    --name autoware-oci \
    autoware -- \
    sh -c 'ros2 launch autoware_launch e2e_simulator.launch.xml vehicle_model:=sample_vehicle sensor_model:=awsim_sensor_kit map_path:=$DIR_MAPS_TARGET/awsim/shinjuku_map/map'
