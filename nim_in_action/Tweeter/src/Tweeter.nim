import asyncdispatch
import jester

routes:
  get "/":
    resp "hello world!"
  
runForever()
