# For example:

# 1 becomes 11 (1 copy of digit 1).
# 11 becomes 21 (2 copies of digit 1).
# 21 becomes 1211 (one 2 followed by one 1).
# 1211 becomes 111221 (one 1, one 2, and two 1s).
# 111221 becomes 312211 (three 1s, two 2s, and one 1).
# Starting with the digits in your puzzle input, apply this process 40 times. What is the length of the result?

# Your puzzle input is 3113322113.

import strformat, strutils, sequtils

proc findDiffCharIdx(input: string):int =
    let first = input[0]
    for i, c in input:
        if c != first:
            return i
    # all the same, diff is len
    return input.len

# too many recursion
# seems that in release this can also be optmise by c compiler
# proc lookAndSay(input: string):string =
#     if input.len < 1:
#         return ""
#     let idx = findDiffCharIdx(input)
#     let num = idx
#     let start = fmt"{num}{input[0]}"
#     return start & lookAndSay(input[idx..^1])

# too large mem
# proc lookAndSay(input: string, acc:string):string =
#     if input.len < 1:
#         return acc
#     let idx = findDiffCharIdx(input)
#     let num = idx
#     let start = fmt"{num}{input[0]}"
#     return lookAndSay(input[idx..^1], acc & start)

# same mem, tail recursion not release mem?
# proc lookAndSay(input: var string, pos:int, acc: var seq[string]) =
#     if pos == input.len:
#         return
#     let idx = findDiffCharIdx(input[pos..^1])
#     let num = idx
#     let start = fmt"{num}{input[pos]}"
#     acc.add(start)
#     lookAndSay(input, pos+num, acc)

proc lookAndSay(input: var string, acc: var seq[string]) =
    var pos = 0
    while pos < input.len:
        # if pos == input.len:
        #     break
        let idx = findDiffCharIdx(input[pos..^1])
        let num = idx
        let start = fmt"{num}{input[pos]}"
        acc.add(start)
        pos += num

proc main() =

    # var ret = lookAndSay("1", "")
    # echo fmt"11 {ret}"
    # ret = lookAndSay("11", "")
    # echo fmt"21 {ret}"
    # ret = lookAndSay("21", "")
    # echo fmt"1211 {ret}"
    # ret = lookAndSay("1211", "")
    # echo fmt"111221 {ret}"
    # ret = lookAndSay("111221", "")
    # echo fmt"312211 {ret}"

    echo "--------------"
    var input = "3113322113"

    for i in 0..<50:
        var acc: seq[string] = @[]
        lookAndSay(input, acc)
        input = acc.join()
        echo i , " ", input.len
    echo fmt"output {input.len}"

main()