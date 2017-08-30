# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

#
# Usage:
#     dev rsync <prj> <user> <host>
#
cmd_main() {
    if [[ $# -lt 3 ]]; then
        dev_info "Usage: dev rsync <prj> <user> <host>" >&2
        return 1;
    fi

    declare prj="$1" wkdir user="$2" host="$3"

    [[ "$1" == "dev" ]] && wkdir="$glb_wkdir" || wkdir="${cfg_projects[$1]}"
    [ -z "$wkdir" ] && echo "Config error in $glb_base/etc/dev.conf" >&2 && return 1

    # -e to specify ssh instead of the default.
    # rsync -aprzv -e ssh --include '*/' --include='*.class' --exclude='*' . server:/path

    # -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
    # -p, --perms                 preserve permissions
    # -r, --recursive             recurse into directories
    # -z, --compress              compress file data during the transfer
    rsync -prv --exclude-from=$glb_base/etc/rsync.excludes $wkdir $user@$host:\$HOME
}

