# Copyright 2019 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_import dev network

dev_apt() {
    declare cmd="apt --no-install-recommends -y $@"

    dev_verbose "$cmd"
    $cmd
}
