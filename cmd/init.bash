
glb_sta=1

#
#
#
cmd_main() {
    dev_run 0 || return $#

    [ -z "$1" ] && echo "Usage: dev --init <prj>" >&2 && return 0

    declare prj="$1" wkdir="${cfg_projects[$1]}"

    [ "$prj" = "dev" ] && echo "Project dev no need init" >&2 && return 1
    [ -z "$wkdir" ] && echo "Config error: cfg_projects[$prj], in $glb_base/etc/dev.conf" >&2 && return 1
    [ -d $wkdir/bin ] || [ -d $wkdir/cmd ] && echo "Project $prj exists" >&2 && return 1

    mkdir -p \
        $wkdir/bin \
        $wkdir/cmd \
        $wkdir/etc/cmd \
        $wkdir/lib \
        $wkdir/var/log \
        $wkdir/var/misc \
        $wkdir/var/pkg \
        $wkdir/var/tmp

    [ -f $wkdir/lib/bootstrap ] || touch $wkdir/lib/bootstrap

    return 1
}
