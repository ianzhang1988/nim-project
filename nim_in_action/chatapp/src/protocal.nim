import json
type
    Message* = object
        username*: string
        message*: string

proc parseMessage*(data: string): Message =
    let dataJson = parseJson(data)
    result.username = dataJson["username"].getStr()
    result.message = dataJson["message"].getStr()

proc createMessage*(username:string, message: string): string =
    result = $(
        %{"username": %username, "message": %message}
    ) & "\c\l"

when isMainModule:
    block:
        let data = """{"username": "John", "message": "Hi!"}"""
        let parsed = parseMessage(data)
        doAssert(parsed.username == "John")
        doAssert(parsed.message == "Hi!")
    block:
        let data = """barfoo"""
        try:
            let parsed = parseMessage(data)
            doAssert false
        except JsonParsingError:
            # echo("err:" & getCurrentExceptionMsg())
            doAssert true
        except:
            doAssert false
    block:
        let expected = """{"username":"dom","message":"hello"}""" & "\c\l"
        doAssert(createMessage("dom", "hello") == expected)

