# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmd_loop1() {
    for file in $(find -type f); do sed -i 's/\\Data\\/\\DataProvider\\/' $file; done
}

cmd_loop2() {
    for file in $(ls /etc/yum.repos.d/*.repo); do
        echo "File: $file"
        if grep -q '^#baseurl' $file; then
            echo "  Matched #baseurl"
        fi
    done
}


