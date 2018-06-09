cmd_loop() {
    for file in $(find -type f); do sed -i 's/\\Data\\/\\DataProvider\\/' $file; done
}


