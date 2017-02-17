
cmd_create() {
    declare line key val
    declare -A correct
    declare -a questions answers

    # Split by line or space
    # for line in $(apropos -s 1 .); do
    #     echo "::$line"
    # done

    # Split only by line
    while read -r line; do
        # xargs (1)            - build and execute command lines from standard input
        # xauth (1)            - X authority file utility
         
        key="${line%%\ *}" # delete longest match of pattern from the end
        val="${line#*\)}"  # delete shortest match of pattern from the beginning
        val="${val#*-}"

        correct[$key]="$val"
        questions[]="$key"
        answers[]="$val"
    done <<< "$(apropos -s 1 .)"

    # for key in "${!correct[@]}"; do
    #     echo "$key ${correct[$key]}"
    # done

    # Quiz

}
