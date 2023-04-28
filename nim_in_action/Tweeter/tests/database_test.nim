import database
import times, os

when isMainModule:
    removeFile("tweeter_test.db")
    var db = newDatabase("tweeter_test.db")
    db.setup()

    db.create(User(username: "zy"))
    db.create(User(username: "elon"))

    db.post(Message(username:"zy", msg:"hi! All.", time:getTime() - 4.seconds))
    db.post(Message(username:"zy", msg:"To Mars, we March!", time:getTime()))

    var zy: User
    doAssert(db.findUser("zy", zy))

    var elon: User
    doAssert(db.findUser("elon", elon))

    db.follow(elon, zy)

    doAssert(db.findUser("elon", elon))

    let msgs = db.findMessages(elon.following)
    echo(msgs)
    doAssert(msgs[0].msg == "To Mars, we March!")
    doAssert(msgs[1].msg == "hi! All.")
    

    echo("All tests finished successfully!")

    db.close()