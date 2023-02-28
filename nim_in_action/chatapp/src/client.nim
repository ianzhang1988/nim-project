import os
import system

echo("Chat application started")

if os.paramCount() == 0:
    quit("Please specify the server address, e.g. ./client localhost")

let serverAddr = paramStr(1)
echo("connect to ", serverAddr)

while true:
    var message = stdin.readLine()
    if message == "#quit":
        break
    
    echo("Sending \"", message, "\"")