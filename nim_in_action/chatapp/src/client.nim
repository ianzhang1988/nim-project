import os, threadpool
import system
import asyncdispatch, asyncnet
import protocal

echo("Chat application started")

if os.paramCount() == 0:
    quit("Please specify the server address, e.g. ./client localhost")

let serverAddr = paramStr(1)
var username = "Anonymous"
if paramStr(2) != "":
    username = paramStr(2)

var socket = newAsyncSocket()

proc connect(socket: AsyncSocket, serverAddr: string, port=7777) {.async.} = 
    echo("connecting to ", serverAddr)
    await socket.connect(serverAddr,port.Port)
    echo("connected")

    while true:
        let line = await socket.recvLine()
        let parsed = parseMessage(line)
        echo(parsed.username, ": ", parsed.message)

asyncCheck connect(socket, "localhost")

var message_f = spawn stdin.readLine()
while true:
    if message_f.isReady:
        var message = ^message_f
        if message == "#quit":
            break
        echo("Sending \"", message, "\"")
        var data = createMessage(username, message)
        asyncCheck socket.send(data)
        message_f = spawn stdin.readLine()
    
    asyncdispatch.poll()