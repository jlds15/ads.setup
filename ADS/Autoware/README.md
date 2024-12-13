# Setup Autoware

## Setup with Image

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

Image's entry point script `ros_entrypoint.sh` will help to correctly set up the environment.

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

