# 定义 C 中的枚举类型

const
  CURLOPT_URL* = 10002
  CURLOPT_WRITEFUNCTION* = 20011
  CURLOPT_WRITEDATA* = 20000 + 11
  CURLE_OK* = 0

  OPT_HTTPGET* = 80

type
    Code* = enum
        CURL_OK = 0

type
    # CurlObjPtr* = pointer
    CurlObjPtr* = ptr CurlObj
    CurlObj* = pointer

proc curl_global_init*(flag: clong): Code {.importc, dynlib: "libcurl.so", discardable.}
proc curl_easy_init*(): CurlObjPtr {.importc, dynlib: "libcurl.so" .}
proc curl_easy_setopt*(curl: CurlObjPtr, option: cint): Code {. importc, varargs, dynlib: "libcurl.so", discardable .}
proc easy_setopt*(curl: CurlObjPtr, option: cint): Code {.cdecl, varargs, dynlib: "libcurl.so", importc: "curl_easy_setopt".}
proc curl_easy_perform*(curl: CurlObjPtr): Code {.importc, dynlib: "libcurl.so", discardable .}
proc curl_easy_cleanup*(curl: CurlObjPtr) {.importc, dynlib: "libcurl.so".}
