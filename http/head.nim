import std/[asyncdispatch, httpclient]
import os
import strutils

var url = paramStr(1)
echo "rul:", url

proc asyncProc(): Future[string] {.async.} =
  var client = newAsyncHttpClient()
  var resp = await client.head(url)

  # just get content-length
  echo parseInt(resp.headers.getOrDefault("Content-Length"))

  var headerList: seq[string] = @[]
  for hk, hv in resp.headers:
    # echo hk, ":", hv
    headerList.add(hk & ":" & hv)
  return headerList.join("\n")

echo waitFor asyncProc()
