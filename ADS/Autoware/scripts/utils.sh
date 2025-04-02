#!/usr/bin/env sh

info() {
    printf '%s\n' " > $*"
}

warn() {
    printf '%s\n' " ! $*"
}

error() {
    printf '%s\n' " x $*" >&2
}

fatal() {
    printf '%s\n' " x $*, aborting ..." >&2
    exit 1
}

check_commands_exist() {
    missing=""
    for cmd in $1; do
        if [ ! -x "$(command -v "$cmd")" ]; then
            missing="$missing $cmd"
        fi
    done
    if [ -n "$missing" ]; then
        error "commands not found:$missing"
        return 1
    fi
    return 0
}
