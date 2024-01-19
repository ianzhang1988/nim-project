import os
import system

proc main() =

    # 读取文件内容
    let content = readFile("input")

    var floor = 0
    let basement = -1
    var position = 0

    for i, c in content:
        if c == '(':
            floor += 1
        elif c == ')':
            floor -= 1

        if floor == basement:
            position = i
            break
    
    echo position + 1
main()