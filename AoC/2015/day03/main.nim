import std/options

type Point = object
    x: int
    y: int

type Grid = object

proc main() =
    var s: seq[Option[int]] = @[]
    s.setLen(100)
    s[99] = some(1)
    echo s[99]

main()