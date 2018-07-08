dev_basename() {
    [ $# -lt 1 ] && return 1
    declare str="$(basename $1)"
    case "$str" in
        *.tar.gz) echo "${str:0:-7}" ;;
        *.tar.bz2) echo "${str:0:-8}" ;;
        *) echo "${str%.*}" ;;
    esac
}
