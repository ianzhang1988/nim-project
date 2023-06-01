import asyncdispatch, times
import jester
import database, views/user, views/general

let db = newDatabase()


proc userLogin(db :Database, request : Request,  user: var User ): bool =
  if request.cookies.hasKey("username"):
    let username = request.cookies["username"]
    if not db.findUser(username, user):
      user = User(username: username, following: @[])
      db.create(user)
    return true
  else:
    return false

routes:
  get "/":
    var user: User
    if userLogin(db, request, user):
      let messages = db.findMessages(user.following & user.username)
      resp renderMain(renderTimeline(user.username, messages))
    else:
      resp renderMain(renderLogin())

  post "/login":
    setCookie("username", @"username", now() + 2.hours)
    redirect("/")

  post "/createMessage":
    let message = Message(
      username: @"username",
      time: getTime(),
      msg: @"message"
    )
    db.post(message)
    redirect("/")

  get "/@name":
    cond '.' notin @"name" # pass /style.css
    var user: User
    if not db.findUser(@"name", user):
      halt "User not Found"
    
    let messages = db.findMessages(@[user.username])

    var currentUser: User
    if db.userLogin(request, currentUser) :
      resp renderMain(renderUser(user, currentUser) & renderMessages(messages))
    else:
      resp renderMain( renderUser(user) & renderMessages(messages))

  post "/follow":
    var follower : User
    var target : User
    if not db.findUser(@"follower", follower):
      halt "follower not Found"
    if not db.findUser(@"target", target):
      halt "target not Found"

    db.follow(follower, target)

    redirect("/" & @"target")

runForever()
