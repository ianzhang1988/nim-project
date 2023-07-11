template repeat( num: int, statements: untyped) =
    for i in 0..<num:
        statements

repeat 3:
    echo("hi!")