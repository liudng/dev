#!/bin/bash
# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# dev_kernel_<xxx>: framework functions;
# cmd_<xxx>: command functions;
# <project>_<xxx>: library functions;
#
# dev_global_<xxx>: global variables;
# dev_conf_<xxx>: configuration variables;

# trace ERR through pipes
set -o pipefail

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

# Importing an entire command file in a particular project
# To import all functions contained in a particular command file
# Usage: dev_import <project> <command-file>
dev_import() {
    if [[ $# -lt 2 ]]; then
        dev_kernel_error "Incorrect import syntax"
        return 1
    fi

    declare import_key="$1/$2"
    if [[ -n "${dev_global_imports[$import_key]+1}" ]]; then
        dev_kernel_debug "Duplicate import: $1 $2"
        return 0
    fi

    if [[ ! -n "${dev_conf_projects[$1]+1}" ]]; then
        dev_kernel_error "Import error, project does not exist: $1"
        return 1
    fi

    declare wkdir="${dev_conf_projects[$1]}"
    declare command_path="$wkdir/lib/$2.bash"

    if [[ ! -f "$command_path" ]]; then
        dev_kernel_error "Import error, library file not found: $command_path"
        return 1
    fi

    source "$command_path"

    dev_global_imports[$import_key]="1"
}

dev_kernel_tip() {
    echo "$@" >&2
}

dev_kernel_error() {
    printf "\e[35m" && echo "$@" && printf "\e[m" >&2
}

dev_kernel_debug() {
    DEV_DEBUG && printf "\e[36m" && echo "[$(whoami)] $@" && printf "\e[m" >&2 || true
}

dev_kernel_help_usage() {
    echo "Usage: dev [--[options[=args]]] <prj> [--[options[=args]]] <cmd-file> <cmd-func> [cmd-args...]"
    echo ""
    echo "Optional arguments:"
    echo "  --help             Help topic and usage information"
    echo "  --version          Output version information and exit"
    echo ""
    echo "Project dependcy optional arguments:"
    echo "  --sudo             Execute a command as another user"
    echo "  --trace            Print command traces before executing command"
    echo "  --verbose          Produce more output about what the program does"
}

dev_kernel_projects() {
    declare prj
    for prj in "${!dev_conf_projects[@]}"; do
        echo "$prj"
    done
}

# Recursively processing subdirectories
# $1: Root directory for scan
dev_kernel_command_files() {
    for i in $(ls $1); do
        if [[ -d $1/$i ]]; then
            dev_kernel_command_files $1/$i $i/
        elif [[ "${i: -5}" == ".bash" ]]; then
            echo "$2${i:0:-5}"
        fi
    done
}

dev_kernel_command_functions() {
    for i in $(compgen -A function); do
        if [[ "${i:0:4}" == "cmd_" ]]; then
            echo "  ${i:4}"
        fi
    done
}

dev_kernel_project_optional_arguments() {
    declare carry=""

    dev_kernel_debug "Project dependency optional argument: $1"
    case "$1" in
        "--sudo")
            declare -gr dev_global_sudo="1"
            ;;
        "--trace")
            declare -gr dev_global_trace="1"
            carry="$1"
            ;;
        "--verbose")
            declare -gr dev_global_verbose="1"
            carry="$1"
            ;;
    esac

    [[ ! -z "$carry" ]] && dev_global_carry="$dev_global_carry $carry" || true
}

declare -gr dev_global_version="2.0"
declare -gr dev_global_self="$(realpath $0)"
declare -gr dev_global_base="$(dirname $(dirname $dev_global_self))"
declare -g  dev_global_conf="$dev_global_base/etc/dev.conf"
declare -gA dev_global_imports=()

# Optional arguments
if [[ $# -gt 0 && "${1:0:1}" == "-" ]]; then
    case "$1" in
        "--conf")
            dev_global_conf="$1"
            shift
            ;;
        "--help")
            dev_kernel_help_usage
            exit 0
            ;;
        "--version")
            echo "dev $dev_global_version"
            exit 0
            ;;
        *)
            echo "Optional argument not found: $1"
            exit 1
            ;;
    esac
fi

# Load configuration file
if [[ ! -f "$dev_global_conf" ]]; then
    dev_kernel_error "Configuration file not found: $dev_global_conf"
    exit 1
fi

source "$dev_global_conf"

# Init project
if [[ $# -le 0 ]]; then
    dev_kernel_tip "These are the all aviliable projects:"
    dev_kernel_tip "$(dev_kernel_projects)"
    exit 1
fi

declare -gr dev_global_project="$1"
shift

# Init project working directory
if [[ ! -n "${dev_conf_projects[$dev_global_project]+1}" ]]; then
    dev_kernel_error "Project not exists: $dev_global_project"
    exit 1
fi

declare -gr dev_global_wkdir="${dev_conf_projects[$dev_global_project]}"

# Init project optional arguments
declare -g dev_global_carry=" "
while [[ $# -gt 0 && "${1:0:1}" == "-" ]]; do
    dev_kernel_project_optional_arguments "$1"
    shift
done

[[ "$dev_global_trace" -eq "1" ]] && set -o xtrace

if [[ "$dev_global_sudo" -eq "1" ]]; then
    dev_kernel_debug "dev_global_carry: $dev_global_carry"
    declare -g dev_global_cmd="$dev_global_self $dev_global_project $dev_global_carry $@"
    dev_kernel_debug "sudo: $dev_global_cmd"
    sudo $dev_global_cmd
else
    # Init command file
    if [[ $# -le 0 ]]; then
        dev_kernel_tip "These are the all aviliable command files:"
        dev_kernel_tip "$(dev_kernel_command_files $dev_global_wkdir/cmd)"
        exit 1
    fi

    declare -gr dev_global_command_file="$dev_global_wkdir/cmd/$1.bash"
    shift

    if [[ ! -f "$dev_global_command_file" ]]; then
        dev_kernel_error "Command file not found: $dev_global_command_file"
        exit 1
    fi

    dev_kernel_debug "dev_global_command_file: $dev_global_command_file"
    source "$dev_global_command_file"

    # Init command function
    if [[ $# -le 0 ]]; then
        dev_kernel_tip "These are the all aviliable command functions:"
        dev_kernel_tip "$(dev_kernel_command_functions)"
        exit 1
    fi

    declare -gr dev_global_command_function="cmd_$1"
    shift

    if [[ "$(declare -F $dev_global_command_function)" != "$dev_global_command_function" ]]; then
        dev_kernel_error "Command function not found: $dev_global_command_function"
        exit 1
    fi

    # Run the function
    $dev_global_command_function $@
fi
