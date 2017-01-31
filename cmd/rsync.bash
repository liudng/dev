
glb_sta=1

#
# Usage:
#     dev_rsync
#
cmd_main() {
    [ -z "$glb_argv" ] && echo "Usage: dev --rsync <prj>" >&2 && return 1
    [ "${#glb_run_nodes[@]}" -le 0 ] && echo "Nodes is empty" >&2 && return 1

    declare user host wkdir

    if [ "$glb_argv" == "dev" ]; then
        wkdir="$glb_base"
    elif [ ! -z "${cfg_projects[$glb_argv]}" ]; then
        wkdir="${cfg_projects[$glb_argv]}"
    else
        echo "Project $glb_argv not exists" >&2 && return 1
    fi

    for host in "${!glb_run_nodes[@]}"; do
        user="${glb_run_nodes[$host]}"

        # -e to specify ssh instead of the default.
        # rsync -aprzv -e ssh --include '*/' --include='*.class' --exclude='*' . server:/path

        # -a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
        # -p, --perms                 preserve permissions
        # -r, --recursive             recurse into directories
        # -z, --compress              compress file data during the transfer
        rsync -prv --exclude-from=$glb_base/etc/rsync.excludes $wkdir $user@$host:$(dirname $wkdir)
    done
}

