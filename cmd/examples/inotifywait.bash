# Copyright 2016 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmd_demo1() {
    # ./.git/ close_write,CLOSE index.lock
    # Pool performance
    while inotifywait -r -e close_write --exclude "./\.git/" ./; do
        # Can not obtain the output of inotifywait.
        # 无法获取inotifywait的输出。
        # Unable to get the output of inotifywait.

        echo "changed"
        sleep 3
        echo "end"
    done
}

cmd_demo2() {
    # ./.git/ close_write,CLOSE index.lock
    # The -m flag monitors the file, instead of exiting on the first event.
    while inotifywait -m -r -e close_write --exclude "./\.git/" ./; do
        # Nothing catch here.
        # 没有什么在这里。
        # Nothing is here.

        # Nothing catched here.
        # 这里什么都没有。
        # Nothing here.

        # Unable to catch the output from inotifywait.
        # 无法捕获inotifywait的输出。
        # Unable to capture the output of inotifywait.

        # Unable to obtain the output of inotifywait.
        # 无法获取inotifywait的输出。
        # Unable to get the output of inotifywait.

        echo "changed"
        sleep 3
        echo "end"
    done
}

cmd_demo3() {
    # ./.git/ close_write,CLOSE index.lock
    # The -m flag monitors the file, instead of exiting on the first event.
    inotifywait -m -r -e close_write --exclude "./\.git/" ./ | while read dir event file; do
        echo "changed"
        sleep 3
        echo $dir
        echo "end"
    done
}

cmd_demo4() {
    # ./.git/ close_write,CLOSE index.lock
    while inotifywait -r -e close_write,delete,move --exclude "\./(\.git|.*/target)/" ./; do
        echo "changed"
    done
}


