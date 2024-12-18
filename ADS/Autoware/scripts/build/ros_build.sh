#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

. "$SCRIPT_DIR/../utils.sh"

AW_REPO=${AW_REPO:-/local/repos/autoware}
AW_TAG=${AW_TAG:-'0.39.1'}

BUILD_ROOT=${SRC_ROOT:-/local/build}
SRC_ROOT="$BUILD_ROOT/src"

info "build: repository directory has been set to $AW_REPO"
info "build: checkout out autoware:$AW_TAG"

if [ ! -d "$AW_REPO" ]; then
    git clone --depth=1 -b "$AW_TAG" https://github.com/autowarefoundation/autoware.git "$AW_REPO"
else
    warn "build: repository exists at $AW_REPO, skipping clone."
fi

mkdir -p "$SRC_ROOT"
vcs import "$SRC_ROOT" <"$AW_REPO/autoware.repos" ||
    fatal 'build: failed to checkout autoware.repos'

info "build: checkout completed."

if [ -n "${BUILD_PACKAGES:-}" ]; then
    info "build: selected packages: $BUILD_PACKAGES"
    BUILD_CMD_PACKAGES="--packages-select $BUILD_PACKAGES"
else
    BUILD_CMD_PACKAGES=''
fi

# build
pushd "$BUILD_ROOT" >/dev/null &&
    eval colcon build $BUILD_CMD_PACKAGES --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release &&
    popd >/dev/null ||
    fatal 'build: failed to build'

info 'build: done.'
