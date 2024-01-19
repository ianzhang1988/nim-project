import std/net

let socket = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)

socket.bindAddr(Port(22222))

var buffer = newString(1024)

while true:
  var address : IpAddress
  var port : Port
  let size = socket.recvFrom(buffer, 4, address, port)
  
  echo "Received ", size, " bytes from ", address, ":", port
  echo "Data: ", buffer[0 ..< size]
  
  socket.sendTo(address, port, "pong")
  echo "sent"