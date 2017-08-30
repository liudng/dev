#!/bin/bash
# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Usage:
#     dev sudoer <sudoer>
#
cmd_main() {
    [ $# -lt 1 ] && dev_info "Usage: dev sudoer <sudoer>" >&2 && return 1

    declare sudoer="$1" home

    if [ "$sudoer" = "root" ]; then
        dev_info "root no need sudo." >&2
        return 1
    fi

    if [ "$(whoami)" = "$sudoer" ]; then
        dev_info "$sudoer exists." >&2
        return 1
    fi

    home="/home/$sudoer"

    if ! getent passwd $sudoer; then
        # Create sudoer
        useradd --create-home $sudoer
        echo "$sudoer:dev" | chpasswd
        usermod -G wheel $sudoer
    fi

    # No-password
    if [ "$(whoami)" == "root" ]; then
        mkdir -p /etc/sudoers.d
        echo "$sudoer ALL=NOPASSWD: ALL" > /etc/sudoers.d/$sudoer-nopasswd
    fi

    # Private and public key
    if [ "$HOME" != "$home" ]; then
        mkdir -m 700 -p $home/.ssh
        cp $HOME/.ssh/id_rsa* $home/.ssh
        cat $HOME/.ssh/id_rsa.pub >> $home/.ssh/authorized_keys
        chown -R $sudoer:$sudoer $home/.ssh
        chmod 600 $home/.ssh/{authorized_keys,id_rsa*}
    fi
}
