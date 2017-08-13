# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmd_main() {
    grep -r --color \
        --exclude=*~ \
        --exclude=*.log \
        --exclude=*.swp \
        --exclude=tags \
        --exclude-dir=.git \
        "$1" .
}
