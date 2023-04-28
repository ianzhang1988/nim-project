# Package

version       = "0.1.0"
author        = "zhangyang08"
description   = "let's go"
license       = "MIT"
srcDir        = "src"
bin           = @["Tweeter"]
skipExt = @["nim"]


# Dependencies

requires "nim >= 1.6.10", "jester >= 0.0.1"
