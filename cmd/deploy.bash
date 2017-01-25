#!/bin/bash

glb_sta=1

#
# Usage:
#     dev_deploy
#
cmd_main() {
    declare wkdir

    [ -z "$glb_argv" ] || [ "$glb_argv" == "dev" ] && wkdir="$glb_wkdir" || wkdir="${cfg_projects[$glb_argv]}"
    [ -z "$wkdir" ] && echo "Config error in $glb_base/etc/dev.conf" >&2 && return 1
    [ "${#glb_run_nodes[@]}" -le 0 ] && echo "Nodes is empty" >&2 && return 1

    declare cmd user host sudoer init_tar=/tmp/devinit.tar

    cmd="mkdir -m 700 -p \$HOME/.ssh &&"
    cmd="$cmd cat > \$HOME/.ssh/authorized_keys &&"
    cmd="$cmd chmod 600 \$HOME/.ssh/authorized_keys"

    [ -f $init_tar ] && rm -f $init_tar

    cd $wkdir
    tar --exclude='./devinit.tar' \
        --exclude='./*.sublime-*' \
        --exclude='./var/log' \
        --exclude='./var/tmp' \
        -cf $init_tar .

    for host in "${!glb_run_nodes[@]}"; do
        sudoer="${glb_run_nodes[$host]}"
        [ -z "$glb_user" ] && user="$sudoer" || user="$glb_user"

        # public key, remotely write to a file using SSH
        # It's will overwrite authorized_keys
        cat $glb_ssh_key.pub | dev_ssh $user@$host "$cmd"
        [ "$user" != "$sudoer" ] && dev_scp $glb_ssh_key $glb_ssh_key.pub $user@$host:\$HOME/.ssh
        dev_scp $init_tar $glb_base/bin/devinstaller $user@$host:/tmp
        dev_ssh $user@$host "/tmp/devinstaller $wkdir $sudoer"
    done

    rm -f $init_tar
}

