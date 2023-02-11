import std/strformat

from strutils import split, replace
from parseutils import parseInt
from math import round

let bytes = 1
let kilobytes = 1_024 * bytes
let megabytes = 1_024 * kilobytes
let gigabytes = 1_024 * megabytes

proc bytesToHuman*(byt: int64): string =
  if byt > gigabytes:
    return &"{round(byt.int/gigabytes,3)}GB"
  if byt > megabytes:
    return &"{round(byt.int/megabytes,3)}MB"
  if byt > kilobytes:
    return &"{round(byt.int/kilobytes,3)}KB"
  return &"{round(byt.int/bytes,3)}B"

proc humanToBytes*(str: string): int64 =
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
