# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_import dev file

cmd_helloworld() {
    echo "Hello World!"
}

cmd_sleep() {
    echo "$(whoami)"
    for i in `seq 1 3`; do
        sleep 1
        echo "$i"
    done
}

cmd_basename() {
    echo "file-1.2.0.tar.gz"
    dev_file_basename "file-1.2.0.tar.gz"
    echo "file-1.2.0.tar.bz2"
    dev_file_basename "file-1.2.0.tar.bz2"
    echo "file-1.2.0.tgz"
    dev_file_basename "file-1.2.0.tgz"
}

cmd_interactive() {
    [[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'
}

cmd_cond() {
    if [[ $# -ge 1 && "$1" =~ ^(xorg|wayland)$ ]]; then
        echo "matched: $1"
    fi

    if [[ $# -ge 2 && ! "$2" =~ ^(none)$ ]]; then
        echo "not none: $2"
    fi

}
