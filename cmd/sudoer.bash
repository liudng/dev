#!/bin/bash
# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Usage:
#     dev sudoer <sudoer> <host>
#
# Example:
#     r1. Set root password:
#        sudo passwd root
#     r2. Relogin use root:
#        exit
#     r3. Remove user vagrant:
#        userdel -f -r vagrant
#     r4. Set network:
#        ifconfig eth1 on
#        ifconfig eth1 192.168.56.70
#      1. Create sudoer:
#        dev -v sudoer ld 192.168.56.70
#     r5. Set hostname:
#        sys --sudo fedora hostname wk
#     r6. Install
#        sys fedora/vbox init xorg
#
cmd_main() {
    [ $# -lt 2 ] && dev_info "Usage: dev sudoer <sudoer> <host>" >&2 && return 1

    declare cmd user="root" host="$2" sudoer="$1"

    cmd="mkdir -m 700 -p \$HOME/.ssh &&"
    cmd="$cmd cat > \$HOME/.ssh/authorized_keys &&"
    cmd="$cmd chmod 600 \$HOME/.ssh/authorized_keys"
    cat $glb_ssh_key.pub | dev_ssh $user@$host "$cmd"
    dev_scp $glb_ssh_key $glb_ssh_key.pub $user@$host:\$HOME/.ssh

    dev_scp $glb_wkdir/bin/sudoer.bash $user@$host:\$HOME

    cmd="\$HOME/sudoer.bash $sudoer"
    dev_ssh $user@$host "$cmd"

    cmd="rm -f \$HOME/.ssh/id_rsa* \$HOME/sudoer.bash && echo \"\" > \$HOME/.ssh/authorized_keys"
    dev_ssh $user@$host "$cmd"

    dev -v deploy dev $sudoer $host
    scp ~/dev/etc/dev.conf $sudoer@$host:~/dev/etc/
    dev -v deploy sys $sudoer $host

    dev_info "done"
}
