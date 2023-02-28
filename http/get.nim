import std/[asyncdispatch, httpclient]
import os

var port = paramStr(1)
echo "port:", port

proc asyncProc(): Future[string] {.async.} =
  var client = newAsyncHttpClient()
  return await client.getContent("http://127.0.0.1:" & port)

echo waitFor asyncProc()
