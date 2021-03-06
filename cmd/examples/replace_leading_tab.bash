# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Replace leading tab charactor to space.
# FIXME Support multiple filter
#
cmd_main() {
    if [[ "$#" -lt 1 ]]; then
        echo "Usage: dev replace_leading_tab *.c" >&2
        return 1
    fi

    declare n="0"

    while grep -R --include="$1" -P '^[ ]*[\t]+' ./
    do
        n=$(($n+1))
        echo "$n"

        find ./ -iname "$1" -type f \
            -exec sed -i 's/^\([ ]*\)\t/\1    /g' \
            {} +
    done
}
