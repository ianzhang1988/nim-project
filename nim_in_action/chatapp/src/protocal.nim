type
    Message* = object
        usrname*: string
        message*: string

proc parseMessage*(data: string): Message =
    discard


