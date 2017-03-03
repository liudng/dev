cmd_main() {
    declare dir="gnu-hello-2.10"
    dev_dextra "http://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz" "$dir.tar.gz" 1
    cd $glb_dest/src/$dir
    ./configure --prefix=$glb_dest/usr
    make && make install
}
