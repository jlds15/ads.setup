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
