# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

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
            echo "${i:4}"
        fi
    done
}


