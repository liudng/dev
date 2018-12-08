#!/bin/bash
# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# trace ERR through pipes
set -o pipefail

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

# Optional arguments
dev_kernel_optional_arguments() {
    declare carry=""
    case "$1" in
        --help)
            dev_run dev help dev_kernel_help_usage
            exit 0
            ;;
        --version)
            dev_kernel_info "dev $dev_global_version"
            exit 0
            ;;
        --completion[^\ ]*)
            dev_global_completion="1"
            carry="$1"
            ;;
        --sudo)
            declare -gr dev_global_sudo="1"
            ;;
        --trace)
            declare -gr dev_global_trace="1"
            carry="$1"
            ;;
        --verbose)
            declare -gr dev_global_verbose="1"
            carry="$1"
            ;;
        *)
            dev_kernel_info "Optional argument not found: $1"
            ;;
    esac

    [[ ! -z "$carry" ]] && dev_global_carry="$dev_global_carry $carry" || true
}

# The dev package version
declare -gr dev_global_version="2.0.1"

# The dev execution file path
declare -gr dev_global_self="$(realpath $0)"

# The dev execution base path
declare -gr dev_global_base="$(dirname $(dirname $dev_global_self))"

# Disable completion default
declare -g dev_global_completion="0"

# Load kernel functions
source "$dev_global_base/lib/kernel.bash"

# Init project
if [[ $# -le 0 ]]; then
    dev_kernel_info "These are the all aviliable projects:"
    dev_kernel_info "$(dev_run dev completion dev_kernel_projects)"
    exit 1
fi

declare -gr dev_global_project="$1"
shift

# Init project working directory
if [[ ! -n "${dev_conf_projects[$dev_global_project]+1}" ]]; then
    dev_kernel_error "Project not exists: $dev_global_project"
fi

declare -gr dev_global_wkdir="${dev_conf_projects[$dev_global_project]}"

# Load working project configuration file
declare -gr dev_working_conf="$dev_global_wkdir/etc/$dev_global_project.conf"
if [[ -f "$dev_working_conf" ]]; then
    source "$dev_working_conf"
fi

declare -g dev_global_carry=""

# Init optional arguments
while [[ $# -gt 0 && "${1:0:1}" == "-" ]]; do
    dev_kernel_optional_arguments "$1"
    shift
done

[[ "$dev_global_trace" -eq "1" ]] && set -o xtrace

if [[ "$dev_global_sudo" -eq "1" ]]; then
    declare -g dev_global_cmd="$dev_global_self $dev_global_project $dev_global_carry $@"
    sudo $dev_global_cmd
else
    # Init command file
    if [[ $# -le 0 ]]; then
        dev_kernel_info "These are the all aviliable command files:"
        dev_kernel_completion "$(dev_run dev completion dev_kernel_command_files $dev_global_wkdir/cmd)"
        exit 1
    fi

    declare -gr dev_global_command_file="$dev_global_wkdir/cmd/$1.bash"
    shift

    if [[ ! -f "$dev_global_command_file" ]]; then
        dev_kernel_error "Command file not found: $dev_global_command_file"
    fi

    source "$dev_global_command_file"

    # Init command function
    if [[ $# -le 0 ]]; then
        dev_kernel_info "These are the all aviliable command functions:"
        dev_kernel_completion "$(dev_run dev completion dev_kernel_command_functions)"
        exit 1
    fi

    if [[ "$dev_global_completion" -eq "1" ]]; then
        exit 0
    fi

    declare -gr dev_global_command_function="cmd_$1"
    shift

    if [[ "$(declare -F $dev_global_command_function)" != "$dev_global_command_function" ]]; then
        dev_kernel_error "Command function not found: $dev_global_command_function"
    fi

    # Run the function
    $dev_global_command_function $@
fi
