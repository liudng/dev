#!/bin/sh

#
# Usage:
#     dev_deploy
#
cmd_deploy() {
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

#
# Usage:
#     dev_rsync
#
cmd_rsync() {
    [ -z "$glb_argv" ] && echo "Usage: dev --rsync <prj>" >&2 && return 1
    [ "${#glb_run_nodes[@]}" -le 0 ] && echo "Nodes is empty" >&2 && return 1

    declare user host wkdir

    if [ "$glb_argv" == "dev" ]; then
        wkdir="$glb_base"
    elif [ ! -z "${cfg_projects[$glb_argv]}" ]; then
        wkdir="${cfg_projects[$glb_argv]}"
    else
        echo "Project $glb_argv not exists" >&2 && return 1
    fi

    for host in "${!glb_run_nodes[@]}"; do
        user="${glb_run_nodes[$host]}"

        # -e to specify ssh instead of the default.
        # rsync -aprzv -e ssh --include '*/' --include='*.class' --exclude='*' . server:/path

        # -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
        # -p, --perms                 preserve permissions
        # -r, --recursive             recurse into directories
        # -z, --compress              compress file data during the transfer
        rsync -prv --exclude-from=$glb_base/etc/rsync.excludes $wkdir $user@$host:$(dirname $wkdir)
    done
}

cmd_init() {
    dev_run 0 || return $#

    [ -z "$1" ] && echo "Usage: dev --init <prj>" >&2 && return 0

    declare prj="$1" wkdir="${cfg_projects[$1]}"

    [ "$prj" = "dev" ] && echo "Project dev no need init" >&2 && return 1
    [ -z "$wkdir" ] && echo "Config error: cfg_projects[$prj], in $glb_base/etc/dev.conf" >&2 && return 1
    [ -d $wkdir/bin ] || [ -d $wkdir/cmd ] && echo "Project $prj exists" >&2 && return 1

    mkdir -p \
        $wkdir/bin \
        $wkdir/cmd \
        $wkdir/etc/cmd \
        $wkdir/lib \
        $wkdir/var/log \
        $wkdir/var/misc \
        $wkdir/var/pkg \
        $wkdir/var/tmp

    [ -f $wkdir/lib/bootstrap ] || touch $wkdir/lib/bootstrap

    return 1
}
