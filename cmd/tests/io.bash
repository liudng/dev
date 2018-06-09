# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_import dev io
dev_import dev io

cmd_color() {
    dev_info "This is a info message."
    dev_success "This is a success message."
    dev_warning "This is a warning message."
    dev_error "This is a error message."
}

cmd_stdout_and_stderr() {
    echo "message-0"
    echo "error-0" >&2

    echo "message-1"
    >&2 echo "error-1"

    echo "message-2"
    >&2 echo "error-2"

    echo "message-3"
    echo "error-3" ">&2"

    exit 1

    echo "message-4"
    >&2 echo "error-4"

    exit 1
}

cmd_color2() {
    echo
    echo -e "$(tput bold) reg  bld  und   tput-command-colors$(tput sgr0)"

    for i in $(seq 1 7); do
      echo " $(tput setaf $i)Text$(tput sgr0) $(tput bold)$(tput setaf $i)Text$(tput sgr0) $(tput sgr 0 1)$(tput setaf $i)Text$(tput sgr0)  \$(tput setaf $i)"
    done

    echo ' Bold            $(tput bold)'
    echo ' Underline       $(tput sgr 0 1)'
    echo ' Reset           $(tput sgr0)'
    echo
}
