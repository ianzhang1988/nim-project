import std/options
import std/tables
import std/strformat

proc point_to_string(x, y :int): string =
    return fmt"{x}_{y}"

proc visit_house(data: string): int =
    var visited= initTable[string, int]()

    var x = 0
    var y = 0

    visited[point_to_string(0,0)] = 1

    
    for move in data:
        case move
        of '^':
            y+=1
        of 'v':
            y-=1
        of '>':
            x+=1
        of '<':
            x-=1
        else: echo "shuld not get into this line"
    
        visited[point_to_string(x,y)]= visited.getOrDefault(point_to_string(x,y)) + 1

    return len(visited)

proc visit_house_with_robo(data: string): int =

    var visited = initTable[string, int]()
    visited[point_to_string(0,0)] = 1

    proc helper(data: string) =

        var x = 0
        var y = 0

        for move in data:
            case move
            of '^':
                y+=1
            of 'v':
                y-=1
            of '>':
                x+=1
            of '<':
                x-=1
            else: echo "shuld not get into this line"
        
            visited[point_to_string(x,y)]= visited.getOrDefault(point_to_string(x,y)) + 1

    var santa = ""
    var robo = ""
    for i, c in data:
        if i.mod(2) == 0:
            santa.add(c)
        else:   
            robo.add(c)

    helper(santa)
    helper(robo)

    return len(visited)

proc main() =

    var num = visit_house(">")
    echo fmt"case1 2 {num}"
    num = visit_house("^>v<")
    echo fmt"case2 4 {num}"
    num = visit_house("^v^v^v^v^v")
    echo fmt"case3 2 {num}"

    num = visit_house_with_robo("^v")
    echo fmt"case1 3 {num}"
    num = visit_house_with_robo("^>v<")
    echo fmt"case2 3 {num}"
    num = visit_house_with_robo("^v^v^v^v^v")
    echo fmt"case3 11 {num}"

    let data = readFile("input")
    echo "result:", visit_house(data)
    echo "robo result:", visit_house_with_robo(data)

main()