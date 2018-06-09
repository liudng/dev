# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# dev_kernel_<xxx>: framework functions;
# cmd_<xxx>: command functions;
# <project>_<xxx>: library functions;
#
# dev_global_<xxx>: global variables;
# dev_conf_<xxx>: configuration variables;

declare -gA dev_global_imports=()

dev_kernel_error() {
    printf "\e[35m" && echo "$@" && printf "\e[m" >&2
    exit 1
}

dev_kernel_info() {
    echo "$@" >&2
}

# Importing an entire command file in a particular project
# To import all functions contained in a particular command file
# Usage: dev_import <project> <command-file>
dev_import() {
    if [[ $# -lt 2 ]]; then
        dev_kernel_error "Incorrect import syntax"
    fi

    declare import_key="$1/$2"
    if [[ -n "${dev_global_imports[$import_key]+1}" ]]; then
        return 0
    fi

    if [[ ! -n "${dev_conf_projects[$1]+1}" ]]; then
        dev_kernel_error "Import error, project does not exist: $1"
    fi

    declare wkdir="${dev_conf_projects[$1]}"
    declare command_path="$wkdir/lib/$2.bash"

    if [[ ! -f "$command_path" ]]; then
        dev_kernel_error "Import error, library file not found: $command_path"
    fi

    source "$command_path"

    dev_global_imports[$import_key]="1"
}

dev_run() {
    if [[ $# -lt 3 ]]; then
        dev_kernel_error "Incorrect run syntax"
    fi

    declare func="$3"
    dev_import $1 $2
    shift 3
    $func $@
}

# Load configuration file
declare -g  dev_global_conf="$dev_global_base/etc/dev.conf"
if [[ -f "$dev_global_conf" ]]; then
    source "$dev_global_conf"
else
    dev_kernel_error "Configuration file not found: $dev_global_conf"
fi

