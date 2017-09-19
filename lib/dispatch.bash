# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Shell Style Guide: https://google.github.io/styleguide/shell.xml
#
# dev_xxx: Framwork functions, declared in bin/dev.
# glb_xxx: Global variables, declared in bin/dev.
#
# opa_rem: Optional arguments description variables(readonly).
# opa_als: Alias of optional arguments(readonly).
# opa_fun_xxx: Optional arguments function.
#
# cfg_xxx: Configurations, declared in config file(readonly).
# cmd_xxx: Command function, declared in xxx.bash files by user.
# xxx: Local varialbes, declared in xxx.bash files by user. Declare
#      function-specific variables with local. Declaration and assignment
#      should be on different lines. for example:
#          local file
#          file="/path/to/file/name"
#      or (only in function)
#          declare file="/path/to/file/name"
#

# trace ERR through pipes
set -o pipefail

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

# config
for cfg in "$glb_base/dev.conf" "$HOME/.dev.conf" "$glb_base/etc/dev.conf"; do
    [ -f $cfg ] && . $cfg && break
done

# Private key: glb_ssh_key
[ -z "$cfg_ssh_key" ] && \
    declare -gr glb_ssh_key="$HOME/.ssh/id_rsa" || \
    declare -gr glb_ssh_key="$HOME/.ssh/$cfg_ssh_key"

# kernal files
. $glb_base/lib/kernel.bash
. $glb_base/lib/options.bash
. $glb_base/lib/functions.bash

#
# Usage:
#     dev_options
#
dev_etr_options() {
    declare opt als ret

    for als in "${!opa_als[@]}"; do
        opt="${opa_als[$als]}"
        ret="$ret --${opt//_/-}" && [ "$opt" != "$als" ] && ret="$ret -$als"
    done

    echo "${ret:1}"
}

#
# Usage:
#     dev_completion
#
dev_etr_completion() {
    declare ret key prj wkdir filename

    dev_prj $@ && shift
    dev_file $@ && shift

    # echo "\$@:$@" >&2
    # echo "cur:$glb_cur" >&2
    # echo "glb_prj:$glb_prj" >&2
    # echo "glb_wkdir:$glb_wkdir" >&2

    if [ "$glb_prj" == "dev" ]; then
        wkdir=$glb_base
        if [ -z $glb_file ]; then
            # List all projects
            for prj in "${!cfg_projects[@]}"; do
                ret="$ret $prj"
            done
        fi
    else
        wkdir=$glb_wkdir
    fi

    if [ -z $glb_file ]; then
        # List files in project
        ret="$ret $(dev_cmd_files $wkdir/cmd | tr '\n' ' ')"
        # List all files in usr/bin,usr/sbin
        ret="$ret $(dev_help_usr_files)"
    else
        # List all cmd-func
        for key in $(compgen -A function); do
            [[ "${key:0:4}" == "cmd_" && "${key:4}" != "main" ]] && ret="$ret ${key:4}"
        done
    fi

    echo "${ret:1}"; return 0
}

dev_etr_command() {
    declare cmd

    # Do command function
    [ $glb_run -lt 1 ] && return 0

	[[ "$glb_run" -ge 1 && "${#glb_run_nodes[@]}" -gt 0 ]] && glb_run="3"

	dev_prj $@ && shift
    [ -z "$glb_prefix" ] && glb_prefix=$glb_wkdir

	dev_file $@ && shift || return 1
	dev_func $@ && shift
    [[ "$glb_usr_file" -eq "0" && -z "$glb_func" ]] && return 1

    if [[ $glb_run -le 2 ]]; then
        # Run in local machine
		dev_exec_local $glb_func $@
    else
        cmd="$glb_base/bin/dev"
        [ $glb_verbose -eq 1 ] && cmd="$cmd --verbose"
        [ "$glb_usr_file" -eq "1" ] && cmd="$cmd --bin"

        dev_exec_remote $cmd $glb_prj $glb_file $glb_func $@
    fi
}

#
# A function called main is required for scripts long enough to contain at
# least one other function.The last non-comment line in the file should be
# a call to main: dev_main "$@"
#
dev_main() {
    if [[ $# -gt 0 && "${1:0:1}" == ":" ]]; then
        glb_etr="${1:1}" && shift
        [ "$glb_etr" == "completion" ] && glb_cur="${1:1}" && shift
    fi

    # Porject name and working directory
    if [ "${1:0:1}" != "-" ]; then
		dev_prj $@ && shift
    fi

    declare opt func args argv shft

    # Prepare optional arguments
    while true ; do
        opt=""; argv=""; shft="true"
        if [[ "$1" == "--" || "$1" == "-" ]]; then
            shift; break
        elif [[ "${1:0:2}" == "--" ]]; then
            opt="${1:2}"; shift
        elif [[ "${1:0:1}" == "-" ]]; then
            [ -z "${opa_als[${1:1}]}" ] && opt="${1:1}" || opt="${opa_als[${1:1}]}"; shift
            [ -z "$opt" ] && echo "Unrecognized option -${1:1}" >&2
        else
            break
        fi

        [ -z $opt ] && continue

        if [[ "$(expr index $opt '=')" -ge 1 ]]; then
            IFS='=' read -ra args <<< "$opt"
            opt="${args[0]}"; argv="${args[1]}";
        elif [[ ! -z "$1" && "${1:0:1}" != "-" ]]; then
            argv="$1"; shft="shift"
        fi

        func="opa_fun_${opt/-/_}"
        if [[ "$(declare -F $func)" == "$func" ]]; then
            $func $argv || $shft
        fi
    done

    dev_etr_$glb_etr $@
}

# Call to main function. custom function declare before here.
dev_main $@
