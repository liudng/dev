#!/data/data/com.termux/files/usr/bin/bash
# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


pkg install git openssh rsync

git clone https://github.com/liudng/dev.git ~/dev
git clone https://gitlab.com/liudng/sys.git ~/sys
# modify /data/data/com.termux/files/home/dev/etc/dev.conf
cd /data/data/com.termux/files/home/dev/bin
ln -s dev.termux dev
cd /data/data/com.termux/files/home/sys/bin
ln -s sys.termux sys

