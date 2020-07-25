# pull-all

Performs a git pull on the current directory and all immediate child directories that are git repositories.

## Usage

``` sh
$ cd path/to/repo/containing/other/repos/as/well

$ ls | cat
build
file1
repo1
repo2
repo3
repo4
repo5
tmp

$ pull-all
. (master)
    Already up to date.

repo1 (branchA)
    Already up to date.

repo2 (branchB)
    Already up to date.

repo3 (branchC)
    Already up to date.

repo4 (branchD)
    Already up to date.

repo5 (branchE)
    Already up to date.
```

## Installation

1. Install [just](https://github.com/casey/just).
2. Install [janet](https://janet-lang.org/).
3. Run `just build`.
4. Copy your new binary in `bin` to a location in your `$PATH`.

Or just [download the latest release](https://github.com/corasaurus-hex/pull-all/releases).
