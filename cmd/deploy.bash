# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Usage:
#     dev deploy <prj> vagrant 192.168.56.70
#
# Example:
#     1. Set root password:
#        sudo passwd root
#     2. Relogin use root:
#        exit
#     3. Remove user vagrant:
#        userdel -f -r vagrant
#     4. Set network:
#        ifconfig eth1 on
#        ifconfig eth1 192.168.56.70
#     5. Deploy dev:
#        dev -v deploy dev root 192.168.56.70
#        scp ~/.dev.conf root@192.168.56.70:/root
#     6. Login to root@192.168.56.70:
#        vi ~/.dev.conf
#     7. Deploy sys:
#        dev -v deploy sys root 192.168.56.70
#     8. Set hostname:
#        sys fedora hostname wk
#     9. Create sudoer:
#        dev -v sudoer ld
#
#
cmd_main() {
    if [[ $# -lt 3 ]]; then
        dev_info "Usage: dev deploy <prj> <user> <host>" >&2
        return 1;
    fi

    declare prj="$1" wkdir user="$2" host="$3"

    [[ "$1" == "dev" ]] && wkdir="$glb_wkdir" || wkdir="${cfg_projects[$1]}"
    [ -z "$wkdir" ] && echo "Config error in $glb_base/etc/dev.conf" >&2 && return 1

    declare cmd init_tar=/tmp/devinit.tar

    [ -f $init_tar ] && rm -f $init_tar

    cd $wkdir

    tar --exclude='./devinit.tar' \
        --exclude='./etc/dev.conf' \
        --exclude='./src' \
        --exclude='./tags' \
        --exclude='./usr' \
        --exclude='./var' \
        -cf $init_tar .

    cmd="mkdir -m 700 -p \$HOME/.ssh &&"
    cmd="$cmd cat >> \$HOME/.ssh/authorized_keys &&"
    cmd="$cmd chmod 600 \$HOME/.ssh/authorized_keys"
    cat $glb_ssh_key.pub | dev_ssh $user@$host "$cmd"

    dev_scp $glb_ssh_key $glb_ssh_key.pub $user@$host:\$HOME/.ssh
    dev_scp $init_tar $user@$host:/tmp

    cmd="mkdir -p \$HOME/$prj/var/log &&"
    cmd="$cmd tar -xf /tmp/devinit.tar -C \$HOME/$prj &&"
    cmd="$cmd rm -f /tmp/devinit.tar &&"
    cmd="$cmd \$HOME/dev/bin/dev.bash init $prj"
    dev_ssh $user@$host "$cmd"

    rm -f $init_tar
}
