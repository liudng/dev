# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_import dev network
#
# Usage:
#     dev_dnf <install|remove> <package-name>
#
dev_dnf() {
    # -4     Resolve to IPv4 addresses only.
    # --allowerasing
    #        Allow  erasing  of  installed  packages  to  resolve dependencies.
    declare cmd="dnf -y --allowerasing -4  --setop=\"install_weak_deps=False\" $@"
    if ! command -v dnf > /dev/null; then
        # Compatible with CentOS 6.x/7.x
        cmd="yum -y $@"
    fi

    dev_verbose "$cmd"
    $cmd
}

#
# Usage:
#     dev_rpm_install <url>
#
dev_rpm_install() {
    declare fname=$(basename $1)
    dev_download $1 $fname

    # fname no extension: ${fname%.*}
    rpm -q ${fname%.*} || rpm -Uvh $dev_global_wkdir/var/downloads/$fname
}

#
# Writing grub.
#
dev_grub2_mkconfig() {
    if [ -f /boot/efi/EFI/fedora/grub.cfg ]; then
        grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    else
        grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
}


