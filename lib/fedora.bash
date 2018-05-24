# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Usage:
#     dev_dnf <install|remove> <package-name>
#
dev_dnf() {
    # -4     Resolve to IPv4 addresses only.
    # --allowerasing
    #        Allow  erasing  of  installed  packages  to  resolve dependencies.
    declare cmd="sudo dnf -y --allowerasing -4 $@"
    if ! command -v dnf > /dev/null; then
        # Compatible with CentOS 6.x/7.x
        cmd="sudo yum -y $@"
    fi

    dev_verbose "$cmd"
    $cmd
}
