import times
import db_sqlite
import strutils
import sequtils

type
    User* = object
        username*: string
        following*: seq[string]
    Message* = object
        username*: string
        time*: Time
        msg*: string

type
    Database* = ref object
        db*: DbConn

proc newDatabase*(filename="tweeter.db"): Database =
    new result
    result.db = open(filename, "", "", "")

proc post*(database: Database, message: Message) =
    if message.msg.len > 140:
        raise newException(ValueError, "> 140")

    database.db.exec(sql"insert into Message values (?, ?, ?);", message.username, $message.time.toUnix(), message.msg)

proc follow*(database: Database, follower: User, user: User) =
    database.db.exec(sql"insert into Following values (?, ?);", follower.username, user.username)

proc create*(database: Database, user: User) = 
    database.db.exec(sql"insert into User values (?);", user.username)

proc findUser*(database: Database, username: string, user: var User) : bool =
    let row = database.db.getRow(sql"select username from User where username=?;", username)
    if row[0].len == 0: return false
    else: user.username = row[0]

    let following = database.db.getAllRows(
        sql"select followed_user from Following where follower=?;", username)
    user.following = @[]
    for row in following:
        if row[0].len != 0:
            user.following.add(row[0])
    return true

proc findMessages*(database: Database, usernames: seq[string], limit = 10): seq[Message] =
    result = @[]
    if usernames.len == 0: return
    
    let users = usernames.map(proc(x:string): string = "'" & x & "'").join(",")
    let whereinCluase = " where username in ($#)" % [users]

    let messages = database.db.getAllRows(sql(
        "select username, time, msg from Message" & whereinCluase & " order by time desc limit " & $limit
    ))

    for row in messages:
        result.add(Message(username: row[0], time: fromUnix(row[1].parseInt()), msg: row[2]))

proc setup*(database: Database) =
    database.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS User(
        username text primary key
    );
    """)
    database.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS Following(
        follower text,
        followed_user text,
        primary key(follower, followed_user),
        FOREIGN KEY (follower) REFERENCES User(username),
        FOREIGN KEY (followed_user) REFERENCES User(username)
    );
    """)
    database.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS Message(
        username text,
        time integer,
        msg test NOT NULL,
        FOREIGN KEY (username) REFERENCES User(username)
    );
    """)

proc close*(database: Database)=
    database.db.close()