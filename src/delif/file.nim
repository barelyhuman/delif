import std/strformat

from os import getFileInfo, PathComponent, walkDirRec, removeDir, removeFile


proc getDirSize*(path: string): int64 =
  var
    size: int64 = 0

  for file in walkDirRec(&"{path}"):
    let info = getFileInfo(file)
    size += info.size

  return size


proc getSize*(path: string): int64 =
  let info = getFileInfo(path)

  if info.kind == PathComponent.pcDir:
    return getDirSize(path)

  if info.kind == PathComponent.pcFile:
    return info.size

proc deleteItem*(path: string) =
  let info = getFileInfo(path)

  if info.kind == PathComponent.pcDir:
    removeDir(path)

  if info.kind == PathComponent.pcFile:
    removeFile(path)
