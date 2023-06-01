proc printf(format: cstring) : cint {. importc, varargs, header: "stdio.h", discardable .}

printf("hi %s\n", "zhang")

type CTime = int64

proc time(args: ptr CTime): CTime {. importc, header:"time.h" .}

var t = time(nil)
echo "seconds: ", t

type
    TM {.importc: "struct tm", header: "<time.h>".} = object
        tm_min: cint
        tm_hour: cint

proc localtime(time: ptr CTime): ptr TM {.importc, header: "<time.h>".}

let tm = localtime(addr t)
echo tm.tm_hour,":",tm.tm_min