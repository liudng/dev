# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_import dev io

#
# https://stackoverflow.com/questions/21109036/select-mysql-query-with-bash
#
cmd_demo2() {
    # loop though the result rows
    while IFS=$'\t' dev_read user_id auth_code; do
        echo "userId: ${user_id} authCode: ${auth_code}"
    done < <($system $select "SELECT user_id, auth_code from user;")
}

cmd_demo1() {
    $system -e "select * from user"
    $system -e "select * from user" | tail -n +2 | while read TABLE
    do
        echo "$TABLE"
    done
}
