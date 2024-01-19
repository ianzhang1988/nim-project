import stat_api_protocal
import std/tables
import std/options
import std/strformat

proc readfile(file: string) :string =
    try:
        let f = open(file, fmRead)
        defer: f.close() # 关闭文件
        result = f.readAll()
    except IOError as e:
        echo &"open {file} failed: {e.msg}"

proc main(work_type: string = "parse", files: seq[string]): int=

    case work_type:
    of "parse":
        if files.len() < 1:
            echo "no file given!"
            return 1
        let data = readfile(files[0])
        let stat = parseStat(data)
        printImportant(stat)

import cligen; dispatch main # Whoa..Just 1 line??