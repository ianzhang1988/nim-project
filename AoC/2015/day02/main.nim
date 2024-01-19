import system
import strutils
import std/strformat
import std/algorithm

proc one_box(dim :string): int =
    let dims = dim.split("x")
    let l = dims[0].parseInt()
    let w = dims[1].parseInt()
    let h = dims[2].parseInt()

    let a = l*w
    let b = l*h
    let c = w*h

    var slack = min([a,b,c])
    return 2*a + 2*b + 2*c + slack

proc find_least(input: seq[int], k: int): seq[int] =
    let sort_seq = sorted(input, system.cmp[int])
    return sort_seq[0..k]

proc one_ribbon(dim :string): int =
    let dims = dim.split("x")
    let l = dims[0].parseInt()
    let w = dims[1].parseInt()
    let h = dims[2].parseInt()

    let least_seq = find_least(@[l,w,h], 2)
    let l1 = least_seq[0]
    let l2 = least_seq[1]

    return 2*l1 + 2*l2 + l*w*h


proc main() =
    let data = readFile("input")
    let lines = data.split("\n")


    echo "$# -- $# " % [$one_box("2x3x4"),$58]
    echo "$# -- $# " % [$one_box("1x1x10"),$43]
    echo "$# -- $# " % [$one_ribbon("2x3x4"),$34]
    echo "$# -- $# " % [$one_ribbon("1x1x10"),$14]

    var sum = 0

    for l in lines:
        sum += one_box(l)

    echo "warpping paper: ", sum

    sum = 0

    for l in lines:
        sum += one_ribbon(l)

    echo "ribbon: ", sum


main()