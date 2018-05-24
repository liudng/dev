# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmd_main() {
    declare dir="gnu-hello-2.10"
    dev_dextra "http://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz" "$dir.tar.gz" 1
    cd $glb_prefix/src/$dir
    ./configure --prefix=$glb_prefix/usr
    make && make install
}
