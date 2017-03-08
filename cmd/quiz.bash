# Copyright 2017 The dev Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

glb_run_compact=1

cmd_main() {
    declare line key val
    declare -A correct
    declare -a questions answers
    declare counter=0
    declare qnum=0 opt1=0 opt2=0 opt3=0 cnum=0
    declare choice

    # Split by line or space
    # for line in $(apropos -s 1 .); do
    #     echo "::$line"
    # done

    echo "Generate questions..."

    # Split only by line
    while read -r line; do
        # Example
        # xargs (1)            - build and execute command lines from standard input
        # xauth (1)            - X authority file utility
         
        key="${line%%\ *}" # delete longest match of pattern from the end
        val="${line#*\)}"  # delete shortest match of pattern from the beginning
        val="${val#*-}"

        # correct[$key]="$val"

        # Append to the end of the arrays.
        questions+=("$key")
        answers+=("$val")

        counter=$(expr $counter + 1)
    done <<< "$(apropos -s 1 .)"

    echo "OK."

    # Echo commands and descriptions
    # for key in "${!correct[@]}"; do
    #     echo "$key: ${correct[$key]}"
    # done

    echo
    echo "Select the correct description of each command."
    echo "    Note: Attempt all questions. Questions have a internal choice."
    echo

    # Quiz
    qnum="$(expr $RANDOM % $counter)"
    cnum="$qnum"

    # Optional answers
    opt1="$(expr $RANDOM % $counter)"
    opt2="$(expr $RANDOM % $counter)"
    opt3="$(expr $RANDOM % $counter)"

    echo "Q1: ${questions[$qnum]}"
    echo "    A. ${answers[$cnum]}"
    echo "    B. ${answers[$opt1]}"
    echo "    C. ${answers[$opt2]}"
    echo "    D. ${answers[$opt3]}"

    echo -n "    Choice:"
    read -n 1 choice
}
