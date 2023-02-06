# delif 

> **del**ete **if**

tiny utility to delete with certain queries. 

> Under development 

## Goals
[ ] Delete based on size 
	[x] Delete based on size greater than `x`
	[ ] Delete based on size lower than `x`
	[ ] Delete only Files
	[ ] Delete only Folders
	[ ] Delete only children (parent folder is left as is)
[x] Dry Run to list files to be deleted

## Installation 

Once the above functionalities have been added, you'll be able to download the binaries from the releases section

## Usage

```sh
$ delif file folder # simply delete the file or folder without any conditions

$ delif --gt="1M" folder # delete folder if it's greater than 1 megabyte

$ delif --dry --gt="1MB" folder # same as above but will dry run instead of actually deleting stuff
```


## License
[MIT](/license)