import os, threadpool
import system

echo("Chat application started")

if os.paramCount() == 0:
    quit("Please specify the server address, e.g. ./client localhost")

let serverAddr = paramStr(1)
echo("connect to ", serverAddr)

while true:
    var message_f = spawn stdin.readLine()
    
    var message = ^message_f
    if message == "#quit":
        break
    
    echo("Sending \"", message, "\"")