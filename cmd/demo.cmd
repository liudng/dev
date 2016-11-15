#!/bin/sh
# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


cmd_helloworld() {
    echo "$arg_hello $arg_world"

    for i in `seq 1 10`;
    do
        sleep 1
        echo "$i"
    done
}

cmd_stdout_and_stderr() {
    echo "message-0"
    echo "error-0" >&2
    echo "message-1"
    >&2 echo "error-1"
    echo "message-2"
    >&2 echo "error-2"
    echo "message-3"
    echo "error-3" ">&2"
    exit 1
    echo "message-4"
    >&2 echo "error-4"
    exit 1
}

cmd_associative_array_looping() {
    declare -A array=(
        [foo]=bar1
        [bar]=foo2
    )

    # The keys are accessed using an exclamation point: ${!array[@]},
    # the values are accessed using ${array[@]}.
    # Note the use of quotes around the variable in the for statement (plus the
    # use of @ instead of *). This is necessary in case any keys include spaces.
    for i in "${!array[@]}"
    do
      echo "key  : $i"
      echo "value: ${array[$i]}"
    done
}