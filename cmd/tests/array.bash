# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

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


