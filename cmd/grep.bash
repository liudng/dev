
glb_sta=1
glb_run_compact=1

cmd_main() {
    grep -r --color \
        --exclude=*~ \
        --exclude=*.log \
        --exclude=*.swp \
        --exclude=tags \
        --exclude-dir=.git \
        "$1" .
}
