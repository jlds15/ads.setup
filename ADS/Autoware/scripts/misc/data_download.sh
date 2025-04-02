#!/usr/bin/env sh

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

. "$SCRIPT_DIR/../utils.sh"

AW_REPO=${AW_REPO:-"$(mktemp -d)"}
AW_TAG=${AW_TAG:-'0.39.1'}
DATA_PATH=${DATA_PATH:-'/root/autoware_data'}

if ! check_commands_exist 'ansible git tar zipinfo'; then
    fatal "missing dependencies"
fi

info "repository directory has been set to $AW_REPO"
info "data path has been set to $DATA_PATH"
info "checkout out autoware:$AW_TAG"

git clone --depth=1 -b "$AW_TAG" https://github.com/autowarefoundation/autoware.git "$AW_REPO"

info "install ansible-galaxy-requirements"
(cd "$AW_REPO" && ansible-galaxy install -r ./ansible-galaxy-requirements.yaml)

ansible-playbook autoware.dev_env.download_artifacts -e "data_dir=$DATA_PATH" ||
    fatal "failed to download autoware data"
