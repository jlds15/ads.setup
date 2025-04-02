# Setup Autoware

## Setup with Image

[![Static Badge](https://img.shields.io/badge/Autoware-0.39.1-blue?style=flat-square)](https://github.com/autowarefoundation/autoware/tree/0.39.1)

You can use the official Autoware (prebuilt) image from their CI pipeline to easily set up your ADS workspace.

### Pre-requirements:

- NVIDIA Support for Containers

  Ensure that you have the NVIDIA driver and NVIDIA container toolkit installed.

- Container Runner

  Install either `docker` (also `docker-compose`) or `podman`.

- Enable Multicast for the Loopback Interface

  Run the following command to enable multicast for the loopback interface:

  ```shell
  sudo ip link set lo multicast on
  ```

- Environment variables

  Few environment variables need to be set up, which can be modified in the [env](./.env) file:

  - `DIR_MAPS`

    Specifies the directory on the host where map data will be bound.
    _Default_: `~/autoware_maps`

  - `DIR_AUTOWARE_DATA`

    Specifies the directory on the host where `autoware_data` will be bound.
    Artifacts can be easily downloaded via this [script](./scripts/misc/data_download.sh).
    _Default_: `~/autoware_data`

  - `DIR_MAPS_TARGET`

    Specifies the directory in the container where map data will be placed.
    _Default_: `/data/maps`

  - `DIR_AUTOWARE_DATA_TARGET`

    Specifies the directory in the container where `autoware_data` will be placed.
    **Note**: This only useful for images don't come with `autoware_data`, e.g., `devel`. Change to `/root/autoware_data` if your want to replace image's original.
    _Default_: `/root/autoware_data_inactivate`

### Run Autoware

A predefined container configuration file in the Compose file format is available. This file provides basic configurations for running Autoware on your host system.

Several helper scripts are also provided for running the following preset commands:

- Official planning demo [[script](./scripts/run_docker_planning_example.sh)]

- AWSIM [[script](./scripts/run_docker_awsim.sh)]

To execute your custom commands, use the following:

```shell
docker compose run --rm \
    --name autoware-oci \
    autoware -- \
    $your_command
```

Entry defined by `ENTRYPOINT ["/ros_entrypoint.sh"]` will help to correctly set up the environment.

If you prefer a more interactive session within the container, you can:

1. Use `docker compose run` with the bash command:

   ```shell
   docker compose run --rm \
       --name autoware-oci \
       autoware -- \
       bash
   ```

2. Or use `docker exec -it` to attach to a running container.

   ```shell
   docker exec -it autoware-oci bash
   ```

**Note**: You will need to manually set up environment variables. e.g., `source` ros's setup scripts.

### Patch & Run Autoware

Traffic light classifier for CUDA is not available out of the box in the current prebuilt images from Autoware. This issue, which may be related to the CI pipeline, can be confirmed by running the relevant package:

```bash
$ ros2 launch tier4_perception_launch traffic_light.launch.xml

# ...

# [component_container_mt-57] [ERROR] [1733908196.002137622] [perception.traffic_light_recognition.traffic_light.classification.car_traffic_light_classifier]: please install CUDA, CUDNN and TensorRT to use cnn classifier
```

To use the `traffic_light_classifier`, you need to rebuild the package using the `devel` image. Follow these steps to apply the patch:

1. Use the development image instead of the runtime Compose file:

   ```shell
   docker compose -f compose.devel.yml run \
       --rm \
       --name autoware-oci \
       autoware -- bash
   ```

2. Once inside the container, run the script to build the traffic_light_classifier package:

   ```shell
   BUILD_PACKAGES=autoware_traffic_light_classifier bash /opt/scripts/build/ros_build.sh
   ```

3. Source the ROS setup script to use the freshly built packages:

   ```shell
   # install dir may vary; the default is under /local/build
   source /local/build/install/setup.bash
   ```
