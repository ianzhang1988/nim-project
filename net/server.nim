import std/net
let socket = newSocket()
socket.bindAddr(Port(22222))
socket.listen()

# You can then begin accepting connections using the `accept` procedure.
var client: Socket
var address = ""
while true:
  socket.acceptAddr(client, address)
  echo "Client connected from: ", address
  var data: string
  data = client.recv(4)
  echo "recv:", data
  client.send("pong")
  client.close()
