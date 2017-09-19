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
#     dev --host <host>
#
opa_rem[host]="Run the command on the specified host"
opa_als[t]="host"
opa_fun_host() {
    [ -z "$1" ] && echo "Usage: dev --host <host>" >&2 && return 0

    glb_run_nodes[$1]="$1"
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
opa_rem[user]="Run the command as a user (only for --host)"
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
opa_rem[version]="Output version information and exit"
opa_als[version]="version"
opa_fun_version() {
    dev_run_level 0 || return 0
    echo "dev version $glb_version"
    return 0
}

#
# Usage:
#     dev --prefix <prj>
#
opa_rem[prefix]="Install architecture-independent files in PREFIX"
opa_als[prefix]="prefix"
opa_fun_prefix() {
    [ -z "$1" ] && echo "Usage: dev --prefix <prj>" >&2 && return 0
    [ -z "${cfg_projects[$1]}" ] && echo "Project $1 not exists" >&2 && return 1
    glb_prefix="${cfg_projects[$1]}" && return 1
}

#
# Usage:
#     dev --verbose
#
opa_rem[verbose]="Produce more output about what the program does"
opa_als[v]="verbose"
opa_fun_verbose() {
    glb_verbose="1"
    return 0
}


#
# Usage:
#     dev --bin
#
opa_rem[bin]="Load command from usr/bin and usr/sbin"
opa_als[b]="bin"
opa_fun_bin() {
    glb_usr_file="1"
    return 0
}
