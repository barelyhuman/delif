import parseopt
import std/strformat
from os import getFileInfo, removeDir, removeFile, PathComponent, walkDirRec
from strutils import split, replace
from parseutils import parseInt

let version="0.0.0"

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
"""

proc getDirSize(path: string): int64 =
  var
    size: int64 = 0

  for file in walkDirRec(&"{path}"):
    let info2 = getFileInfo(file)
    size += info2.size

  return size
  

proc getSize(path: string): int64 =
  let info = getFileInfo(path)

  if info.kind == PathComponent.pcDir:
    return getDirSize(path)

  if info.kind == PathComponent.pcFile:
    return info.size


proc humanToBytes(str: string): int64 =
  let bytes = 1
  let kilobytes = 1_024 * bytes
  let megabytes = 1_024 * kilobytes
  let gigabytes = 1_024 * megabytes

  var size: int
  discard parseInt(str, size)
  let unit = str.replace(&"{size}", "")
  var valueInBytes: int64
  case unit
    of "GB", "G":
      valueInBytes = size * gigabytes
    of "MB", "M":
      valueInBytes = size * megabytes
    of "KB", "K":
      valueInBytes = size * kilobytes
    of "B":
      valueInBytes = size * bytes

  return valueInBytes

proc deleteItem(path: string) =
  let info = getFileInfo(path)

  if info.kind == PathComponent.pcDir:
    removeDir(path)

  if info.kind == PathComponent.pcFile:
    removeFile(path)

proc cli() =
  var
    argCtr: int
    sizeLimit: int64 = -1
    folders: seq[string]
    dryRun: bool = false

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
      of "gt":
        sizeLimit = humanToBytes(value)
      else:
        echo "Unknown option: ", key
    of cmdEnd:
      discard

  for pathToDel in folders:
    let size = getSize(pathToDel)
    var deleteable = true

    if sizeLimit != 0 and size < sizeLimit:
      deleteable = false

    if deleteable:
      if not dryRun:
        deleteItem(pathToDel)
      echo &"Deleting {pathToDel}"

when isMainModule:
  cli()
