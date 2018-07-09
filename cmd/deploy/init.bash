# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_import dev io

cmd_main() {
    [ -z "$1" ] && echo "Usage: dev deploy/init main <prj>" >&2 && return 1

    declare prj="$1" wkdir="${dev_conf_projects[$1]}"

    if [[ -z "${dev_conf_projects[$1]}" ]]; then
        echo "Project $prj not exists" >&2
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

    [ ! -L $HOME/bin/$prj ] && ln -s $wkdir/bin/$prj.bash $HOME/bin/$prj

    if [ ! -f $wkdir/.gitignore ]; then
        echo "/src" > $wkdir/.gitignore
        echo "/usr" >> $wkdir/.gitignore
        echo "/var" >> $wkdir/.gitignore
    fi

    cd $wkdir/usr
    [ ! -L $wkdir/usr/etc ] && ln -s ../etc etc
    [ ! -L $wkdir/usr/src ] && ln -s ../src src
    [ ! -L $wkdir/usr/var ] && ln -s ../var var

    dev_verbose "done"
}
