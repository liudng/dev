# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
#
#
cmd_main() {
    [ -z "$1" ] && echo "Usage: dev init <prj>" >&2 && return 1

    declare prj="$1" wkdir="${cfg_projects[$1]}"

    if [[ "$1" = "dev" ]]; then
        wkdir="$glb_base"
    elif [[ -z "${cfg_projects[$1]}" ]]; then
        echo "Project $1 not exists" >&2
        return 1
    fi

    mkdir -p $HOME/bin $HOME/.local/{bin,lib,lib64,share}
    mkdir -p $wkdir/{src,usr} $wkdir/var/{misc,pkg}
    mkdir -m a+w -p $wkdir/var/{log,tmp}

    if [ ! -f $HOME/.bash_completion ]; then
        touch $HOME/.bash_completion
    fi

    if [ -f $wkdir/lib/completion.bash ]; then
        grep -q "_dev_init_completion" $HOME/.bash_completion || \
            cat $wkdir/lib/completion.bash >> $HOME/.bash_completion
    fi

    grep -q "complete -F _dev_init_completion $prj" $HOME/.bash_completion || \
        echo "complete -F _dev_init_completion $prj" >> $HOME/.bash_completion

    [ ! -L $HOME/bin/$prj ] && ln -s $wkdir/bin/$prj.bash $HOME/bin/$prj

    [ ! -f $wkdir/lib/bootstrap.bash ] && touch $wkdir/lib/bootstrap.bash

    dev_verbose "done"
}
