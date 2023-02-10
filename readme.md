# delif

> **del**ete **if**

tiny utility to delete with certain queries.

> Under development

## Goals

- [ ] Delete based on size
  - [x] Delete based on size greater than `x`
  - [x] Delete based on size lower than `x`
  - [x] Delete only Files
  - [x] Delete only Folders
  - [ ] Delete only children (parent folder is left as is)
- [x] Dry Run to list files to be deleted

## Installation

Once the above functionalities have been added, you'll be able to download the binaries from the releases section

## Usage

```sh
$ delif file directory # simply delete the file or directory without any conditions

$ delif --gt="1M" directory # delete directory if it's greater than 1 megabyte

$ delif --dry --gt="1MB" directory # same as above but will dry run instead of actually deleting stuff

$ delif -d directory file # delete only directories from a list of files and directories

$ delif -f directory file # delete only files from a list of files and directories
```

## License

[MIT](/license)
