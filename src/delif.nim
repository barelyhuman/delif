import parseopt
import std/strformat

from delif/file import getSize, deleteItem
from delif/bytes import humanToBytes, bytesToHuman
from delif/utils import isDeletableBySize, isDeletableByType

let version = "0.0.0"

proc writeHelp() =
  echo &"""
delif {version}

  USAGE:

    $ delif [flags] <path-to-file-or-folder>

  FLAGS:

  -h            Print this help 
  -v            Print current version
  --dry         Show what will be deleted without actually deleting it
  --gt=SIZE     Delete files/folders greater than SIZE
  --lt=SIZE     Delete files/folders less than SIZE
  -d            Delete only directories
  -f            Delete only files
"""

proc cli() =
  var
    argCtr: int
    greaterThanSize: int64 = -1
    lessThanSize: int64 = -1
    folders: seq[string]
    dryRun: bool = false
    onlyFolders: bool = false
    onlyFiles: bool = false

  for kind, key, value in getOpt():
    case kind

    # Positional arguments
    of cmdArgument:
      folders.add(key)
      argCtr.inc

    # Switches
    of cmdLongOption, cmdShortOption:
      case key
      of "v", "version":
        echo &"{version}"
        quit()
      of "h", "help":
        writeHelp()
        quit()
      of "dry":
        dryRun = true
      of "d":
        onlyFolders = true
      of "f":
        onlyFiles = true
      of "gt":
        greaterThanSize = humanToBytes(value)
      of "lt":
        lessThanSize = humanToBytes(value)
      else:
        echo "Unknown option: ", key
    of cmdEnd:
      discard

  for pathToDel in folders:
    let size = getSize(pathToDel)

    var deleteable = isDeletableBySize(
      lessThanSize,
      greaterThanSize,
      size,
    )

    deleteable = isDeletableByType(pathToDel, onlyFiles, onlyFolders)

    if deleteable:
      if not dryRun:
        deleteItem(pathToDel)
      echo &"Deleting {pathToDel}: {bytesToHuman(size)}"




when isMainModule:
  cli()
