# dev - Lightweight Bash Scripts Manager

[![License](https://img.shields.io/badge/license-BSD-blue.svg?style=flat)](https://github.com/liudng/dev/blob/master/LICENSE)

For large and complex software projects need to setup the development
environment, including software installation dependents,  clone source code
repository, manage a large number of scripts, custom configuration files, and so on.

The goal of `dev` is to make these things easier.

> This documentation assumes you are already familiar with Bash. If you do not know anything about Bash, consider familiarizing yourself with the general terminology and features of Bash before continuing.

## Featues

* Writen in pure bash.
* Modular.
* Lightweight.

## Installation

Clone the [dev](https://github.com/liudng/dev) repository to a local directory:

```sh
git clone git@github.com:liudng/dev.git ~/dev
```

Add ~/dev/bin to the PATH variable:

```sh
echo "export PATH=$PATH:~/dev/bin" >> ~/.bashrc
```

Or link ~/dev/bin/dev.bash to a PATH directory:

```sh
ln -s ~/dev/bin/dev.bash ~/.local/bin/dev
ln -s ~/dev/bin/dev-bootstrap.bash ~/.local/bin/dev-bootstrap
```

Create a configuration file:

```sh
cp ~/dev/etc/dev.conf.example ~/dev/etc/dev.conf
```

If you want to use the command auto completion, run the following command:

```sh
cat ~/dev/share/completion.bash >> ~/.bash_completion
```

The installation is complete, enter `dev --help` at the command line to see how to use it.

## Usage

```sh
dev [--sudo] [--trace] [--verbose] <cmd-file> <cmd-function> [arguments...]
dev [--help] [--version]
```

[dev](https://github.com/liudng/dev)'s custom commands are saved in the cmd directory, and the file extension
must be `.bash`, In the help topic it is named **cmd-file**. In each command
file, **cmd-function** is prefixed with *cmd_*.

## Example

Type the folloing command:

```sh
dev examples/example helloworld
```

Output:

```sh
Hello world!
```

## Custom Command Example

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

Output:

```sh
Hello world!
```

In the above command, **demo** is cmd-file. **helloworld** is cmd-function.

> You can save all project-related commands in the cmd directory.

More examples, see the files in th [cmd](https://github.com/liudng/dev/tree/master/cmd) directory.

## Multi-project

Using [dev](https://github.com/liudng/dev) to manage multiple projects is very easy.

...

More project examples, see the [sys](https://github.com/liudng/sys) project.

## Copyright

Copyright 2017 The [dev](https://github.com/liudng/dev) Authors. All rights reserved.

Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
