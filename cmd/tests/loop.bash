# Copyright 2018 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmd_loop() {
    for file in $(find -type f); do sed -i 's/\\Data\\/\\DataProvider\\/' $file; done
}


