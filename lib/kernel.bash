# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

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
# Verbose
#
dev_verbose() {
    [ $dev_global_verbose -eq 1 ] && dev_info "[$(whoami)] $@" >&2 || true
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
