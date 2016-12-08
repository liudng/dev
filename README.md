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