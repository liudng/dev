# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

declare -g glb_version="1.8.1"

# Run-state:
# 0:Not-run(readonly)
# 1:Run(alterable,local,default)
# 2:Run(readonly,local)
# 3:Run(readonly,remote)
declare -g glb_run=1 glb_run_dry=0 glb_run_sudo=0 glb_run_daemon=0 glb_verbose=0

# Command file
declare -g glb_file glb_func glb_user="$USER" glb_prefix glb_etr="command"

# For option arguments
declare -Ag glb_run_nodes opa_rem opa_als

#
# Usage information.
#
dev_help_usage() {
    declare files="<cmd-file>"
    [ ! -z "$1" ] && files="$1"

    echo "Usage: dev [--[options [args]]] [prj] $files <cmd-func> [cmd-args] ..."
    echo "       dev [--[options [args]]] [args] ..."; echo
}

#
# List all options
#
dev_help_options() {
    echo "Optional arguments:"; echo
    dev_help_options_items |sort; echo
}

#
# List all options
#
dev_help_options_items() {
    declare opt sht als

    for als in "${!opa_als[@]}"; do
        opt="${opa_als[$als]}"
        [ "$opt" != "$als" ] && sht=", -$als" || sht=""
        echo -e "  --${opt//_/-}$sht \t ${opa_rem[$opt]}"
    done

    # for i in $(compgen -A function); do
    #     if [[ "${i:0:8}" == "opa_fun_" ]]; then
    #         opt="${i:8}"
    #     fi
    # done
}

#
# Usage:
#     dev_help_projects
#
dev_help_projects() {
    declare ret prj wkdir

    if [ "$glb_prj" == "dev" ]; then
        wkdir=$glb_base
        if [ -z $glb_file ]; then
            # List all projects
            echo "These are the all aviliable <prj>s:"; echo
            for prj in "${!cfg_projects[@]}"; do
                ret="$ret $prj"
            done
            echo ${ret:1} |tr " " "\n" |sort |column -c $(tput cols); echo
        fi
    else
        wkdir=$glb_wkdir
    fi

    if [ -z $glb_file ]; then
        # List files in project
        dev_help_files $wkdir
    else
        # List all cmd-func
        dev_help_functions $wkdir $1
    fi
}

#
# List all command files.
#
dev_help_files() {
    declare wkdir
    [ -z "$1" ] && wkdir="$glb_wkdir" || wkdir="$1"
    [ -z $wkdir ] && return 0
    echo "These are the all aviliable <cmd-file>s:"; echo

    declare ret
    ret="$ret $(dev_cmd_files $wkdir/cmd)"
    echo ${ret:1} |tr " " "\n" |sort |column -c $(tput cols); echo
}

#
# List all functions of included <cmd-file>s.
#
dev_help_functions() {
    declare wkdir
    [ -z "$1" ] && wkdir="$glb_wkdir" || wkdir="$1"
    echo "These are the all aviliable <cmd-func>s:"; echo

    for i in $(compgen -A function); do
        if [[ "${i:0:4}" == "cmd_" ]]; then
            echo -e "  ${i:4} \t in $wkdir/cmd/$glb_file:$i()"
        fi
    done

    echo
}

#
# Usage:
#     dev_load_files <prj> <cmd-file>
#
dev_load_files() {
    declare wkdir="$1" cf="$2"
    [ -f $wkdir/lib/bootstrap.bash ] && . $wkdir/lib/bootstrap.bash
    [ -f $wkdir/cmd/$cf.var ] && . $wkdir/cmd/$cf.var
    [ ! -f $wkdir/cmd/$cf.bash ] && return 1 || . $wkdir/cmd/$cf.bash
}

#
# Recursively process subdirectories
#
dev_cmd_files() {
    for i in $(ls $1); do
        if [[ -d $1/$i ]]; then
            dev_cmd_files $1/$i $i/
        elif [[ "${i: -5}" == ".bash" ]]; then
            echo "$2${i:0:-5}"
        fi
    done
}

#
# Usage:
#     dev_prj <prj>
#
dev_prj() {
    [[ ! -z "$glb_prj" ]] && return 1

    if [ "$1" == "dev" ]; then
        declare -gr glb_prj="dev" glb_wkdir=$glb_base; return 0
    fi

    if [ $# -ge 1 ] && [ -n "${cfg_projects[$1]+1}" ]; then
        declare -gr glb_prj="$1" glb_wkdir=${cfg_projects[$1]}; return 0
    fi

	declare -gr glb_prj="dev" glb_wkdir=$glb_base; return 1
}

#
# Prepare command files
# Usage:
#     dev_file <cmd-file>
#
dev_file() {
    [ ! -z "$glb_file"] && return 1

    if [[ $# -le 0 || -z "$1" ]]; then
        dev_help_projects >&2; return 1
    fi

    if ! dev_load_files $glb_wkdir $1; then
        dev_error "Command file not found: $glb_wkdir/cmd/$1.bash" >&2; return 1
    fi

    glb_file="$1"; return 0
}

#
# Set execution function
#
dev_func() {
    if [ ! -z "$glb_func" ]; then
        dev_error "\$glb_func has a value: $glb_func" >&2; return 1
    fi

    # File is command(stand alone)
    if [[ "$(declare -F cmd_main)" == "cmd_main" ]]; then
        glb_func="cmd_main"; return 1
    fi

    if [[ $# -le 0 || -z "$1" ]]; then
        dev_error "Missing command function" >&2; echo >&2; dev_help_functions >&2; return 1
    fi

    declare func=${1/-/_}

    [[ "${func:0:4}" == "cmd_" || -z "$glb_file" ]] || func="cmd_$func"
    if [[ "$(declare -F $func)" != "$func" ]]; then
        dev_error "Command not found: $func" >&2; return 1
    fi

    glb_func="$func"
}

#
# Set run state
# Run-state:
# 0:Not-run(readonly)
# 1:Run(alterable,local,default)
# 2:Run(readonly,local)
# 3:Run(readonly,remote)
#
dev_run_level() {
    if [[ "$glb_run" -eq 1 ]]; then
        glb_run="$1"; return 0
    else
        dev_error "\$glb_run has a value: $glb_run" >&2; return 1
    fi
}


#
# Execute a command from all nodes.
# Usage:
#     dev_exec_remote dev [options] <cmd-file> <cmd-func> [cmd-args]
#
dev_exec_remote() {
    if [[ "${#glb_run_nodes[@]}" -le 0 ]]; then
        dev_error "Nodes is empty" >&2; return 1
    fi

    declare cmd host

    for host in "${!glb_run_nodes[@]}"; do
        cmd="ssh -i $glb_ssh_key -o StrictHostKeyChecking=no $glb_user@$host"
        [ $glb_run_sudo -eq 1 ] && cmd="$cmd sudo"

        set +o errexit
        dev_exec $host $glb_user $cmd $@
        set -o errexit

        echo
    done
}

#
# Usage:
#     dev_exec_local <command> <arguments>...
#
dev_exec_local() {
    declare host="127.0.0.1" user="$(whoami)" cmd
    cmd="$host $user"
    if [[ $glb_run_sudo -eq 1 ]]; then
        cmd="$cmd sudo $glb_base/bin/dev"
        [ $glb_verbose -eq 1 ] && cmd="$cmd --verbose"
        cmd="$cmd $glb_prj $glb_file"
    fi
    dev_exec $cmd $@
}

#
# Usage:
#     dev_exec <host> <user> <command> <arguments>...
#
dev_exec() {
    declare host="$1"; shift
    declare user="$1"; shift
    declare cmd="$@"
    declare desc="[$user@$host $(date '+%Y-%m-%d %H:%M:%S')]"
    declare logout="$glb_wkdir/var/log/$host.log"

    echo "$desc" >>$logout
    echo "$cmd" >>$logout
    chmod a+wx $logout

    [ $glb_run_dry -eq 1 ] && return 0

    dev_verbose "$cmd"

    if [ $glb_run_daemon -eq 1 ]; then
        nohup $cmd >>$logout 2>&1 &
        dev_info "PID: $!" >&2
    else
        if [[ "$1" = "sudo" ]]; then
            $cmd
        else
            $cmd 2>&1 | tee -a $logout
        fi
    fi
}

#
#
#
dev_basename() {
    [ $# -lt 1 ] && return 1
    declare str="$(basename $1)"
    case "$str" in
        *.tar.gz) echo "${str:0:-7}" ;;
        *.tar.bz2) echo "${str:0:-8}" ;;
        *) echo "${str%.*}" ;;
    esac
}
