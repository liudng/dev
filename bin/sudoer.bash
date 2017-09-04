#!/bin/bash
# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

[ $# -lt 1 ] && echo "Usage: dev sudoer <sudoer>" >&2 && return 1

declare sudoer="$1" home="/home/$1"

if [[ "$sudoer" = "root" || "$(whoami)" = "$sudoer" ]]; then
    echo "$sudoer exists." >&2
    return 1
fi

# Create sudoer
if ! getent passwd $sudoer; then
    useradd --create-home $sudoer
    echo "$sudoer:$sudoer" | chpasswd
    usermod -G wheel $sudoer
fi

# No-password
mkdir -p /etc/sudoers.d
echo "$sudoer ALL=NOPASSWD: ALL" > /etc/sudoers.d/$sudoer-nopasswd

# Private and public key
mkdir -m 700 -p $home/.ssh
cp $HOME/.ssh/id_rsa* $home/.ssh
cat $HOME/.ssh/id_rsa.pub > $home/.ssh/authorized_keys
chown -R $sudoer:$sudoer $home/.ssh
chmod 600 $home/.ssh/{authorized_keys,id_rsa*}
