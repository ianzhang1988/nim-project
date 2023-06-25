import curl

# proc writeCallback(ptr: cstring, size: int, nmemb: int, userdata: cvoidptr): int =
#   let data = cast[cstring](userdata)
#   let totalSize = size * nmemb
#   data.add(totalSize) = '\0' # 添加字符串终止符
#   data.add(totalSize) = ptr
#   return totalSize

proc curlWriteFn(
  buffer: cstring,
  size: int,
  count: int,
  outstream: pointer): int =

  echo "curlWriteFn 1 ", repr(outstream)
  
  let outbuf = cast[ref string](outstream)

  echo "curlWriteFn 2 ", repr(outbuf)
  if outbuf == nil:
      echo "outbuf nil"
  else:
      outbuf[] = "test"

  outbuf[] &= buffer
  result = size * count

  echo "result", result

proc performGetRequest(url: cstring): string =
  # var response = newString(0)
  let response: ref string = new string

  echo "perform 0", repr(response)

  curl_global_init(3)

  var curlHandle = curl_easy_init()
  
  
  if curlHandle != nil:
    curl_easy_setopt(curlHandle, CURLOPT_URL, url)
    curl_easy_setopt(curlHandle, OPT_HTTPGET, 1)
    # curl_easy_setopt(curlHandle, CURLOPT_WRITEDATA, cast[pointer](response))
    curl_easy_setopt(curlHandle, CURLOPT_WRITEDATA, response)
    #curl_easy_setopt(curlHandle, CURLOPT_WRITEFUNCTION, curlWriteFn)
    discard curlHandle.easy_setopt( CURLOPT_WRITEFUNCTION, curlWriteFn)

    echo "perform 1"    
    
    if curl_easy_perform(curlHandle) == CURL_OK:
      # result = response[]
      echo response[]
    
    echo "perform 2" 

    curl_easy_cleanup(curlHandle)

    echo "perform 3" 
  
  return "test"#response[]

# 在主程序中执行 HTTP GET 请求
var url = "http://www.baidu.com"
var response = performGetRequest(cstring(url))
echo response