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
    dev_basename "abc-1.2.0.tar.gz"
    dev_basename "abc-1.2.0.tar.bz2"
    dev_basename "abc-1.2.0.tgz"
}
