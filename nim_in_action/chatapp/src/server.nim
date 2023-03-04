import asyncdispatch, asyncnet

type
    Client = ref object
        socket: AsyncSocket
        netAddr: string
        id: int
        connected: bool
    Server = ref object
        socket: AsyncSocket
        clients: seq[Client]

proc newServer(): Server =
    return Server(socket: newAsyncSocket(), clients: @[])

proc `$` (client: Client): string = 
    $client.id & "(" & client.netAddr & ")"

proc processMessages(server: Server, client: Client) {.async.} = 
    while true:
        let line = await client.socket.recvLine()
        if line.len == 0:
            echo(client, "disconnected")
            client.connected = false
            client.socket.close()
            return
        echo(client, " sent: ", line)


proc serve( server: Server, port = 7777) {.async.} = 
    server.socket.bindAddr(port.Port)
    server.socket.listen()

    while true:
        let (netAddr, clientConn) = await server.socket.acceptAddr()
        echo "client connection accepted from ", netAddr
        let client = Client(
            socket: clientConn,
            netAddr: netAddr,
            id: server.clients.len(),
            connected: true,
        )
        server.clients.add(client)
        asyncCheck processMessages(server, client)

var server = newServer()
waitFor serve(server)
