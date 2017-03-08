# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Usage:
#     dev --help
#
opa_rem[help]="Help topic and usage information"
opa_als[h]="help"
opa_fun_help() {
    if [[ $# -le 0 || -z "$1" ]]; then
        dev_run_level 0 || return 0
        dev_help_usage
        dev_help_options
        return 0
    else
        dev_run_level 0 || return 1
        dev_help_usage "$1"
        dev_help_options
        return 1
    fi
}

#
# Usage:
#     dev --target <host>
#
opa_rem[target]=""
opa_als[t]="target"
opa_fun_target() {
    [ -z "$1" ] && echo "Usage: dev --target <host>" >&2 && return 0

    if [ "$1" == "all" ]; then
        declare host
        for host in "${!cfg_nodes[@]}"; do
            glb_run_nodes[$host]="${cfg_nodes[$host]}"
        done
        return 1
    fi

    [ -z "${cfg_nodes[$1]}" ] && echo "Node not found: $1" >&2 && return 1
    glb_run_nodes[$1]="${cfg_nodes[$1]}"
    return 1
}

#
# Usage:
#     dev --daemon
#
opa_rem[daemon]="Run a command immune to hangups, with output to a non-tty"
opa_als[daemon]="daemon"
opa_fun_daemon() {
    glb_run_daemon=1
    return 0
}

#
# Usage:
#     dev -u
#     dev --sudo
#
opa_rem[sudo]="Execute a command as another user"
opa_als[u]="sudo"
opa_fun_sudo() {
    glb_run_sudo=1
    return 0
}

#
# Usage:
#     dev --xtrace
#
opa_rem[xtrace]="Print command traces before executing command"
opa_als[xtrace]="xtrace"
opa_fun_xtrace() {
    set -o xtrace
    # Prints shell input lines as they are read
    # set -o verbose
    return 0
}

#
# Usage:
#     dev --user <user>
#
opa_rem[user]=""
opa_als[user]="user"
opa_fun_user() {
    [ -z "$1" ] && echo "Usage: dev --user <user>" >&2 && return 0
    glb_user="$1"
    return 1
}

#
# Usage:
#     dev --dry-run
#
opa_rem[dry-run]="Only report what would be done"
opa_als[dry-run]="dry-run"
opa_fun_dry_run() {
    glb_run_dry=1
    return 0
}

#
# Usage:
#     dev --version
#
opa_rem[version]=""
opa_als[version]="version"
opa_fun_version() {
    dev_run_level 0 || return 0
    echo "dev version $glb_version"
    return 0
}

#
# Usage:
#     dev --dest <prj>
#
opa_rem[dest]="Destination"
opa_als[dest]="dest"
opa_fun_dest() {
    [ -z "$1" ] && echo "Usage: dev --dest <prj>" >&2 && return 0
    [ -z "${cfg_projects[$1]}" ] && echo "Project $1 not exists" >&2 && return 1
    glb_dest="${cfg_projects[$1]}" && return 1
}
