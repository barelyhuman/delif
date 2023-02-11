from os import getFileInfo, PathComponent


proc isDeletableBySize*(lt: int64, gt: int64, size: int64): bool =
  if gt > -1 and size < gt:
    return false
  elif lt > -1 and size > lt:
    return false

  return true


proc isDeletableByType*(filePath: string, onlyFiles: bool,
    onlyFolders: bool): bool =
  let info = getFileInfo(filePath)
  
  if info.kind == PathComponent.pcDir and onlyFiles:
    return false

  if info.kind == PathComponent.pcFile and onlyFolders:
    return false

  return true
