# dev - Help developers effectively manage projects

[![License](https://img.shields.io/badge/license-BSD-blue.svg?style=flat)](https://github.com/liudng/dev/blob/master/LICENSE)

For large and complex software projects need to setup the development 
environment, including software installation dependents,  clone source code 
repository, manage a large number of scripts, custom configuration files, and so on.

How to make these things easier, it is [dev](https://github.com/liudng/dev)'s goal. 

> Use [dev](https://github.com/liudng/dev) to be familiar with linux and bash.

## Why use dev?

* Keep all projects with the same directory structure.
* Each project has a separate environment.
* Record requirements and configuration changes.

## Featues

* Writen in pure bash.
* Quickly initialize a new development environment.
* Consistent directory structure for multiple projects.
* All commands are stored in the cmd directory and can be reused.
* Manage several aspects of a project, including configurations, repositories and documentation etc.

## Installation

Clone the [dev](https://github.com/liudng/dev) repository to a local directory:

```sh
git clone git@github.com:liudng/dev.git ~/dev
```

Add ~/dev/bin to the PATH variable:

```sh
echo "export PATH=$PATH:~/dev/bin" >> ~/.bashrc
ln -s ~/dev/bin/dev.bash ~/dev/bin/dev
```

Or link ~/dev/bin/dev.bash to a PATH directory:

```sh
ln -s ~/dev/bin/dev.bash ~/.local/bin/dev
```

The installation is complete, enter `dev --help` at the command line to see how to use it.

If you want to use the command auto completion, run the following command:

```sh
cat ~/dev/lib/completion.bash >> ~/.bash_completion
```

## Usage

```sh
dev [-options] [project] <cmd-file> <cmd-func> [arguments...]
```

[dev](https://github.com/liudng/dev)'s custom commands are saved in the cmd directory, and the file extension 
must be `.bash`, In the help topic it is named **cmd-file**. In each command 
file, **cmd-func** is prefixed with *cmd_*.

## Example

Create a new command to copy the following text to the file ~/dev/cmd/demo.bash:

```sh
cmd_helloworld() {
    echo "Hello world!"
}
```

And then type the following command to run:

```sh
dev demo helloworld
```

In the above command, **demo** is cmd-file. **helloworld** is cmd-func.

> You can save all project-related commands in the cmd directory.

More examples, see the files in th [cmd](https://github.com/liudng/dev/tree/master/cmd) directory.

## Multi-project

Using [dev](https://github.com/liudng/dev) to manage multiple projects is very easy.

...

More project examples, see the [sys](https://github.com/liudng/sys) project.

## Copyright

Copyright 2017 The [dev](https://github.com/liudng/dev) Authors. All rights reserved.

Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
