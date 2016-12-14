# dev

Development environment initialization and deployment toolkit.

* Manage several aspects of a project, including command, repositories, password etc.
* Run the command on all nodes (--all) or specified nodes (--node=slave).
* Only run on local machine (default), most are for debugging.
* Verify that all nodes are ready to run the command.
* When a node runs a command that fails, you can customize a handler function.
* Console Password Manager
* Multiple SCM repository management tool


## Usage

```sh
dev [-options] [project] <cmd-file> <cmd-func> [arguments] ...
dev <-options> [project] [arguments] ...
```

## Notes

* Shell style configuration files.
