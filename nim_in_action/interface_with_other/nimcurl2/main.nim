import curl

proc curlWriteFn(
  buffer: cstring,
  size: int,
  count: int,
  outstream: pointer): int =
  
  let outbuf = cast[ref string](outstream)

  echo "curlWriteFn ", repr(addr outbuf[])
  
  outbuf[] = "test"
  outbuf[] &= buffer
  result = size * count
  
let webData: ref string = new string
echo "main ", repr(addr webData[])
let myCurl = easy_init()

discard myCurl.easy_setopt(OPT_USERAGENT, "Mozilla/5.0")
discard myCurl.easy_setopt(OPT_HTTPGET, 1)
# discard myCurl.easy_setopt(OPT_WRITEDATA, webData)
discard easy_setopt(myCurl, OPT_WRITEDATA, webData)
discard myCurl.easy_setopt(OPT_WRITEFUNCTION, curlWriteFn)
discard myCurl.easy_setopt(OPT_URL, "http://www.baidu.com")

let ret = myCurl.easy_perform()
if ret == E_OK:
  echo("yes!!")
  echo(webData[0..100])