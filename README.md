# dev

Development environment initialization and deployment toolkit.

* Run on all machines (default).
* Run the command on the specified machines (-b master,slave, --batch=master,slave).
* Only run on local machine (-l, --local), most are for debugging.
* Run a system(Non-dev) command (-s, --sys), not download dev from remote host.
* Verify that all nodes are ready to run the command.
* When a machine runs a command that fails, you can customize a handler function.

## Useage

```sh
dev --deploy root
```

```sh
/
    bin
    cmd
    dst
        bin
        etc > ../etc
        lib
        sbin
        share
        var > ../var
    etc
    lib
    src
        ...
    var
        log
        tmp
```

```sh
#
# Shell Style Guide: https://google.github.io/styleguide/shell.xml
#
# dev_xxx: Framwork functions, declared in bin/dev.
# glb_xxx: Global variables, declared in bin/dev.
#
# opa_rem: Optional arguments description variables(readonly).
# opa_als: Alias of optional arguments(readonly).
# opa_fun_xxx: Optional arguments function.
# opa_xxx:     Optional global variables.
#
# cfg_xxx: Configurations, declared in config file(readonly).
# cmd_xxx: Command function, declared in xxx.cmd files by user.
# xxx: Local varialbes, declared in xxx.cmd files by user. Declare
#      function-specific variables with local. Declaration and assignment
#      should be on different lines. for example:
#          local file
#          file="/path/to/file/name"
#      or (only in function)
#          declare file="/path/to/file/name"
#
# $@ 2>&1 | tee $log_out
# ($@ | tee $log_out) 3>&1 1>&2 2>&3 | tee $log_err

```