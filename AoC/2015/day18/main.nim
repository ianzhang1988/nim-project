# A # means "on", and a . means "off".
# Then, animate your grid in steps, where each step decides the next configuration based on the current one. Each light's next state (either on or off) depends on its current state and the current states of the eight lights adjacent to it (including diagonals). Lights on the edge of the grid might have fewer than eight neighbors; the missing ones always count as "off".

# For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered 1 through 8, and the light marked B, which is on an edge, only has the neighbors marked 1 through 5:

# 1B5...
# 234...
# ......
# ..123.
# ..8A4.
# ..765.
# The state a light should have next is based on its current state (on or off) plus the number of neighbors that are on:

# A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
# A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
# All of the lights update simultaneously; they all consider the same current state before moving to the next.

import strutils

let inputTest = """.#.#.#
...##.
#....#
..#...
#.#..#
####.."""

let inputTest2 = """##.#.#
...##.
#....#
..#...
#.#..#
####.#"""

type
    State = enum
        On,
        Off
    Grid = seq[seq[State]]

proc newGrid(row:int, col:int): Grid = 
    result.newSeq(row)
    for y,r in result:
        result[y].newSeq(col)

proc `$`(g: var Grid): string =
    for row in g:
        for col in row:
            var c: char
            case col
            of Off:
                c = '.'
            of On:
                c = '#'
            result &= c
        result &= "\n"

proc neighbors(g: var Grid, x:int, y:int): seq[State] =
    let n1 = (y+1, x-1)
    let n2 = (y+1, x)
    let n3 = (y+1, x+1)
    let n4 = (y, x-1)
    let n5 = (y, x+1)
    let n6 = (y-1, x-1)
    let n7 = (y-1, x)
    let n8 = (y-1, x+1)

    for i in [n1, n2, n3, n4, n5, n6, n7, n8]:
        let (y,x) = i
        if min(y,x) < 0 or max(y,x) >= g.len:
            result.add(Off)
            continue
        result.add(g[y][x])

proc ruleWhenOn(neighbors: seq[State]): State =
    var OnCount: int
    for s in neighbors:
        if s == On:
            OnCount+=1
    if OnCount == 2 or OnCount == 3:
        return On
    return Off

proc ruleWhenOff(neighbors: seq[State]): State =
    var OnCount: int
    for s in neighbors:
        if s == On:
            OnCount+=1

    if OnCount == 3:
        return On

    return Off


proc next(g: var Grid) =
    var newG = newGrid(g.len, g[0].len)

    for y, row in g:
        for x, col in row:
            let neighborSeq = neighbors(g, x, y)
            if col == On:
                newG[y][x] = ruleWhenOn(neighborSeq)
            if col == Off:
                newG[y][x] = ruleWhenOff(neighborSeq)

    g = newG

# part2 four lights, one in each corner, are stuck on and can't be turned off
proc next2(g: var Grid) =
    var newG = newGrid(g.len, g[0].len)

    for y, row in g:
        for x, col in row:
            let neighborSeq = neighbors(g, x, y)
            if col == On:
                newG[y][x] = ruleWhenOn(neighborSeq)
            if col == Off:
                newG[y][x] = ruleWhenOff(neighborSeq)

    g = newG

    g[0][0] = On
    g[0][^1] = On
    g[^1][0] = On
    g[^1][^1] = On

proc parse(input: string): Grid =
    let lines = input.splitLines()
    result.newSeq(lines.len)

    for y, l in lines:
        result[y].newSeq(l.len)
        for x, c in l:
            case c
            of '.':
                result[y][x] = Off
            of '#':
                result[y][x] = On
            else:
                assert(false, "should not get here")

# After 4 steps:
# ......
# ......
# ..##..
# ..##..
# ......
# ......

# part2 After 5 steps:
# ##.###
# .##..#
# .##...
# .##...
# #.#...
# ##...#

# In your grid of 100x100 lights, given your initial configuration, how many lights are on after 100 steps?
proc main() = 

    let input = readFile("input")
    var grid = parse(input)

    # part2
    grid[0][0] = On
    grid[0][^1] = On
    grid[^1][0] = On
    grid[^1][^1] = On

    for i in 1..100:
        grid.next2()
    
    # echo grid
    
    var counter = 0
    for row in grid:
        for col in row:
            if col == On:
                counter+=1
    echo "On num: ", counter

main()
