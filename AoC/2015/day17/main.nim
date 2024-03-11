import strutils, math

let input = """33
14
18
20
45
35
16
35
1
13
18
13
50
44
48
6
24
41
30
42"""

let inputTest =  """20
15
10
5
5"""

# For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters, there are four ways to do it:

# 15 and 10
# 20 and 5 (the first 5)
# 20 and 5 (the second 5)
# 15, 5, and 5
# Filling all containers entirely, how many different combinations of containers can exactly fit all 150 liters of eggnog?



proc backtraceSearch(volume: int, containers: seq[int] , acc: var int) =
    if volume == 0:
        # echo "remain:", containers
        acc += 1
        return

    if volume < 0:
        return

    # not correct when there is same value item
    # if volume in containers:
    #     acc += 1
    #     return

    # permutation
    # for i, c in containers:
    #     let newContainers = containers[0..<i] & containers[i+1..^1]
    #     echo "debug:", newContainers
    #     backtraceSearch(volume - c, newContainers, acc)

    if volume > sum(containers):
        return

    # combinations
    for i, c in containers:
        let newContainers = containers[i+1..^1]
        # echo "debug:", newContainers
        backtraceSearch(volume - c, newContainers, acc)

# -- Part Two ---
# While playing with all the containers in the kitchen, another load of eggnog arrives! The shipping and receiving department is requesting as many containers as you can spare.

# Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How many different ways can you fill that number of containers and still hold exactly 150 litres?

# In the example above, the minimum number of containers was two. There were three ways to use that many containers, and so the answer there would be 3.
proc backtraceSearch2(volume: int, containers: seq[int] , acc: var int, leastNum: var int, num: int) =
    if volume == 0:
        if num < leastNum:
            leastNum = num
            acc = 0
        if num == leastNum:
            acc += 1
        return

    if volume < 0:
        return

    if volume > sum(containers):
        return

    # combinations
    for i, c in containers:
        let newContainers = containers[i+1..^1]
        backtraceSearch2(volume - c, newContainers, acc, leastNum, num + 1)


proc combinations( volume: int, containers: seq[int]): int =
    # backtraceSearch(volume, containers, result)
    var leastNum = containers.len
    backtraceSearch2(volume, containers, result, leastNum, 0)

proc main() =
    # let volume = 25
    # let containersStr = inputTest.splitLines()
    let volume = 150
    let containersStr = input.splitLines()
    var containersSize: seq[int]
    for c in containersStr:
        containersSize.add(c.parseInt())

    echo containersSize
    echo "num:", combinations(volume, containersSize)


main()