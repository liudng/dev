# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmd_main() {
    if [ $# -lt 1 ] || [ "$1" == "" ]; then
        echo "Usage: dev find_and_delete keywords"
        return 1
    fi

    find -iname "$1" -print0 -exec rm {} +
}
