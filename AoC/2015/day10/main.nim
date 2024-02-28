# For example:

# 1 becomes 11 (1 copy of digit 1).
# 11 becomes 21 (2 copies of digit 1).
# 21 becomes 1211 (one 2 followed by one 1).
# 1211 becomes 111221 (one 1, one 2, and two 1s).
# 111221 becomes 312211 (three 1s, two 2s, and one 1).
# Starting with the digits in your puzzle input, apply this process 40 times. What is the length of the result?

# Your puzzle input is 3113322113.

import strformat, strutils, sequtils

when compileOption("profiler"):
  import nimprof

# Entry: 1/9 Calls: 2543/2555 = 99.53% [sum: 2543; 2543/2555 = 99.53%]
#   /root/.choosenim/toolchains/nim-2.0.0/lib/system/iterators_1.nim: [] 2544/2555 = 99.57%
#   /root/.choosenim/toolchains/nim-2.0.0/lib/system.nim: lookAndSay 2551/2555 = 99.84%
# so iterators is slow
# proc findDiffCharIdx(input: string):int =
#     let first = input[0]
#     for i, c in input:
#         if c != first:
#             return i
#     # all the same, diff is len
#     return input.len

# Entry: 1/10 Calls: 2498/2515 = 99.32% [sum: 2498; 2498/2515 = 99.32%]
#   /root/.choosenim/toolchains/nim-2.0.0/lib/system/indices.nim: [] 2498/2515 = 99.32%
#   /root/.choosenim/toolchains/nim-2.0.0/lib/system.nim: lookAndSay 2509/2515 = 99.76%
# proc findDiffCharIdx(input: string):int =
#     var diff = 0
#     let first = input[0]
#     while diff < input.len:
#         if input[diff] != first:
#             return diff
#         diff += 1
#     return input.len

proc findDiffCharIdx(input: var string, start: int):int =
    var diff = start
    let first = input[start]
    while diff < input.len:
        if input[diff] != first:
            return diff - start
        diff += 1
    return (input.len - start)

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

# this is good
# probably, in func above new string used most cpu
proc lookAndSay(input: var string, acc: var seq[string]) =
    var pos = 0
    while pos < input.len:
        let idx = findDiffCharIdx(input, pos)
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

# recursion in nim is not well supported. in this case, it's leaky. some momeory is not released.
