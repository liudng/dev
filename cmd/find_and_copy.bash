# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmd_main() {
    if [ $# -lt 2 ] || [ "$1" == "" ] || [ -z "$2" ]; then
        echo "Usage: dev find_and_copy <keywords> <dist-dir>"
        return 1
    fi

    find -iname "$1" -exec cp {} $2 \;
}
