# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

dev_kernel_help_usage() {
    echo "Usage: dev [--[options[=args]]] <prj> [--[options[=args]]] <cmd-file> <cmd-func> [cmd-args...]"
    echo ""
    echo "Optional arguments:"
    echo "  --help             Help topic and usage information"
    echo "  --version          Output version information and exit"
    echo ""
    echo "Project dependcy optional arguments:"
    echo "  --sudo             Execute a command as another user"
    echo "  --trace            Print command traces before executing command"
    echo "  --verbose          Produce more output about what the program does"
}


