#!/bin/sh
# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


cmd_helloworld() {
    for i in `seq 1 3`; do
        sleep 1
        echo "$i"
    done
    echo "$arg_hello $arg_world"
}

cmd_associative_array_looping() {
    declare -A array=(
        [foo]=foofoo
        [bar]=barbar
    )

    # The keys are accessed using an exclamation point: ${!array[@]},
    # the values are accessed using ${array[@]}.
    # Note the use of quotes around the variable in the for statement (plus the
    # use of @ instead of *). This is necessary in case any keys include spaces.
    for i in "${!array[@]}"; do
      echo "key  : $i    value: ${array[$i]}"
    done
}
