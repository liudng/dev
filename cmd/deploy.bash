# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_import dev io
dev_import dev network

cmd_init() {
    [ -z "$1" ] && echo "Usage: dev deploy init <prj>" >&2 && return 1

    declare prj="$1" wkdir="${dev_conf_projects[$1]}"

    if [[ -z "${dev_conf_projects[$1]}" ]]; then
        dev_error "Project not found, add the following line to $dev_global_base/etc/dev.conf:" >&2
        dev_error "  [$prj]=$HOME/$prj" >&2
        return 1
    fi

    mkdir -p $HOME/bin $HOME/.local/{bin,lib,lib64,share}
    mkdir -p $wkdir/{bin,cmd,etc,lib,src,usr} $wkdir/var/downloads
    mkdir -m a+w -p $wkdir/var/{log,tmp}

    if [ ! -f $HOME/.bash_completion ]; then
        touch $HOME/.bash_completion
    fi

    if [ -f $dev_global_base/share/completion.bash ]; then
        grep -q "_dev_init_completion" $HOME/.bash_completion || \
            cat $dev_global_base/share/completion.bash >> $HOME/.bash_completion
    fi

    grep -q "complete -F _dev_init_completion $prj" $HOME/.bash_completion || \
        echo "complete -F _dev_init_completion $prj" >> $HOME/.bash_completion

    if [ ! -f $wkdir/bin/$prj ]; then
        echo "#!/bin/bash" > $wkdir/bin/$prj
        echo "dev-bootstrap.bash $prj \$@" >> $wkdir/bin/$prj
        chmod a+x $wkdir/bin/$prj
    fi

    # [ -L $HOME/bin/dev ] || ln -s $dev_global_base/bin/dev $HOME/bin/dev
    [ -L $HOME/bin/dev-bootstrap.bash ] || ln -s $dev_global_base/bin/dev-bootstrap.bash $HOME/bin/dev-bootstrap.bash
    [ -L $HOME/bin/$prj ] || ln -s $wkdir/bin/$prj $HOME/bin/$prj

    if [ ! -f $wkdir/.gitignore ]; then
        echo "/src" > $wkdir/.gitignore
        echo "/usr" >> $wkdir/.gitignore
        echo "/var" >> $wkdir/.gitignore
    fi

    cd $wkdir/usr

    [ -L $wkdir/usr/etc ] || ln -s ../etc etc
    [ -L $wkdir/usr/src ] || ln -s ../src src
    [ -L $wkdir/usr/var ] || ln -s ../var var

    dev_verbose "done"
}

cmd_nopasswd() {
    [ $# -lt 1 ] && dev_error "Usage: dev deploy nopasswd <sudoer>" >&2 && return 1

    declare sudoer="$1"

    # No-password
    mkdir -p /etc/sudoers.d
    echo "$sudoer ALL=NOPASSWD: ALL" > /etc/sudoers.d/$sudoer-nopasswd

}
#
# Usage:
#     dev deploy rsync <prj> <user_and_host>
#
cmd_rsync() {
    if [[ $# -lt 2 ]]; then
        dev_info "Usage: dev deploy rsync <prj> <user_and_host>" >&2
        return 1;
    fi

    declare prj="$1" wkdir="${dev_conf_projects[$1]}" user_and_host="$2"

    if [[ -z "${dev_conf_projects[$1]}" ]]; then
        dev_error "Project not found, add the following line to $dev_global_base/etc/dev.conf:" >&2
        dev_error "  [$prj]=$HOME/$prj" >&2
        return 1
    fi

    # -e to specify ssh instead of the default.
    # rsync -aprzv -e ssh --include '*/' --include='*.class' --exclude='*' . server:/path

    # -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
    # -C, --cvs-exclude           auto-ignore files in the same way CVS does
    # -l, --links                 copy symlinks as symlink
    # -p, --perms                 preserve permissions
    # -r, --recursive             recurse into directories
    # -z, --compress              compress file data during the transfer
    # --delete
    #rsync -alprz \
    #    --exclude-from=$dev_global_base/etc/rsync.excludes \
    #    $wkdir $user_and_host:\$HOME

    scp -r -p $wkdir $user_and_host:\$HOME/.
}

cmd_sudoer() {
    [ $# -lt 2 ] && dev_error "Usage: dev deploy sudoer <sudoer> <user_and_host>" >&2 && return 1

    declare sudoer="$1" user_and_host="$2"

    dev_scp $glb_wkdir/share/sudoer.bash $user@$host:\$HOME

    cmd="chmod a+x \$HOME/sudoer.bash; \$HOME/sudoer.bash $sudoer; rm \$HOME/sudoer.bash"
    dev_ssh $user@$host "$cmd"

    dev_verbose "done"
}

cmd_hostname() {
    declare host_name="$(hostname)"

    # [ $# -ge 1 ] && host_name="$1"
    # hostnamectl set-hostname $1

    grep -q "127.0.0.1[[:space:]]\{1,\}$host_name" /etc/hosts || \
        sed -i "\$a 127.0.0.1   $host_name" /etc/hosts
    grep -q "::1[[:space:]]\{1,\}$host_name" /etc/hosts || \
        sed -i "\$a ::1         $host_name" /etc/hosts
}

