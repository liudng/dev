cmd_wait_until() {
    declare the_counter="0"
    until ping -c 1 192.168.1.1; do
        the_counter="$(($the_counter + 1))"
        echo "[$the_counter] Waiting network..."
        [[ $the_counter -gt 10 ]] && exit 1 || sleep 1
    done
}
