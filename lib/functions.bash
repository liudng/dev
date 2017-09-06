# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Usage:
#     dev_scp <user-host> <command>
#
dev_scp() {
    declare cmd="scp -i $glb_ssh_key -o StrictHostKeyChecking=no $@"
    dev_verbose "$cmd"
    $cmd
}

#
# Usage:
#     dev_ssh <user-host> <command>
#
dev_ssh() {
    declare cmd="ssh -i $glb_ssh_key -o StrictHostKeyChecking=no $@"
    dev_verbose "$cmd"
    $cmd
}

#
# Usage:
#     dev_dnf
#
dev_dnf() {
    # -4     Resolve to IPv4 addresses only.
    # --allowerasing
    #        Allow  erasing  of  installed  packages  to  resolve dependencies.
    declare cmd="sudo dnf -y --allowerasing -4 $@"
    if ! command -v dnf > /dev/null; then
        # Compatible with CentOS 6.x/7.x
        cmd="sudo yum -y $@"
    fi

    dev_verbose "$cmd"
    $cmd
}

#
# Usage:
#     dev_download <url> [fname]
#
dev_download() {
    [ -z $1 ] && return 1
    [ -z $2 ] && local fname=$(basename $1) || local fname=$2
    [ -z $fname ] && return 1

    declare opts fp=$glb_wkdir/var/pkg/$fname tfp=/tmp/$fname

    if [[ -f $fp ]]; then
        dev_verbose "File exists: $fp"
        return 0
    fi

    # Delete temp file
    [[ -f $tfp ]] && rm -f $tfp

    [ ! -z $cfg_proxy ] && opts="-k -x $cfg_proxy"

    declare cmd="curl $opts -L $1 -o $tfp"

    dev_verbose "$cmd"

    # Delete the temporary files generated by the download
    if ! $cmd && [ -f $tfp ]; then
        rm -f $tfp
    fi

    [[ -f $tfp ]] && cp $tfp $fp
}

#
# Usage:
#     dev_extra <fname> <extra-dir> <strip-components>
#
dev_extra() {
    [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] && echo "Usage: dev_extra <fname> <strip-components>" >&2 && return 1
    declare fp=$glb_wkdir/var/pkg/$1 sp=$glb_wkdir/src/$2
    [ ! -z $glb_wkdir ] && [ ! -z "$2" ] && [ -d $sp ] && rm -rf $sp
    mkdir -p $sp
    tar --strip-components $3 -xzf $fp -C $sp
}

#
# Download and extract to src/<dir>.
# Usage:
#     dev_dextra <url> <fname> <strip-components>
#
#     example:
#         Download to var/pkg/nginx-1.2.0.tar.gz
#         Extra to src/nginx-1.2.0
#         dev_dextra http://xxx.com/v1.2.0.tar.gz nginx-1.2.0.tar.gz 1
#
dev_dextra() {
    [[ $# -lt 3 ]] && echo "Usage: dev_dextra <url> <fname> <strip-components>" >&2 && return 1
    declare url="$1" fname="$2"
    declare exdir="$(dev_basename $fname)"
    dev_download $url $fname
    dev_extra $fname $exdir $3
}

#
# Red
#
dev_error() {
    printf "\e[31m" && echo "$@" && printf "\e[m"
}

#
# Green
#
dev_success() {
    printf "\e[32m" && echo "$@" && printf "\e[m"
}

#
# Yellow
#
dev_warning() {
    printf "\e[33m" && echo "$@" && printf "\e[m"
}

#
# Blue
#
dev_info() {
    printf "\e[34m" && echo "$@" && printf "\e[m"
}

#
# dev_read prevents collapsing of empty fields
# https://stackoverflow.com/questions/21109036/select-mysql-query-with-bash
#
dev_read() {
    local input

    IFS= read -r input || return $?

    while (( $# > 1 )); do
        IFS= read -r "$1" <<< "${input%%[$IFS]*}"
        input="${input#*[$IFS]}"
        shift
    done

    IFS= read -r "$1" <<< "$input"
}

#
# Verbose
#
dev_verbose() {
    if [ $glb_verbose -eq 1 ]; then
        dev_info "$@" >&2
    fi

    return 0
}
