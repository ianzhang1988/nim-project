template repeat( num: int, statements: untyped) =
    for i in 0..<num:
        statements

repeat 3:
    echo("hi!")

proc main() =
    repeat 3:
        echo("hi! from main.")

main()