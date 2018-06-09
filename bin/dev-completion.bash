#!/bin/bash
# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# trace ERR through pipes
set -o pipefail

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

declare -gr dev_global_self="$(realpath $0)"
declare -gr dev_global_base="$(dirname $(dirname $dev_global_self))"
source "$dev_global_base/lib/kernel.bash"


