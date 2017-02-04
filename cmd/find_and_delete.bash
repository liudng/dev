
glb_sta=1
glb_run_compact=1

cmd_main() {
    if [ $# -lt 1 ] || [ "$1" == "" ]; then
        echo "Usage: dev find_and_delete keywords"
        return 1
    fi

    find -iname "$1" -print0 -exec rm {} +
}
