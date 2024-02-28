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

proc findDiffCharIdx(input: string):int =
    let first = input[0]
    for i, c in input:
        if c != first:
            return i
    # all the same, diff is len
    return input.len

# too large mem
# proc lookAndSay(input: string, acc:string):string =
#     if input.len < 1:
#         return acc
#     let idx = findDiffCharIdx(input)
#     let num = idx
#     let start = fmt"{num}{input[0]}"
#     return lookAndSay(input[idx..^1], acc & start)

proc lookAndSay(input: var string, pos:int, acc: var string) =
    if pos == input.len:
        return
    var num: int
    block:
        let idx = findDiffCharIdx(input[pos..^1])
        num = idx
        # block: # $idx allocates! so get it to deallocate before the tail call.
        #     acc &= $idx
        # acc &= $input[pos] # this uses nimAddCharV1, so it's fine to put it outside
        # above is good
        acc &= fmt"{num}{input[pos]}" # this may leak memory
    lookAndSay(input, pos+num, acc)

proc lookAndSayVec(input: var string, pos:int, acc: var seq[string]) =
    if pos == input.len:
        return
    var num: int
    block:
        let idx = findDiffCharIdx(input[pos..^1])
        num = idx
        block:
            let start = fmt"{num}{input[pos]}"
            acc.add(start)
    lookAndSayVec(input, pos+num, acc)


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

    for i in 0..<40:
        block:
            var acc: string
            # var acc: seq[string]
            lookAndSay(input, 0, acc)
            input = acc
        echo i , " ", input.len
    echo fmt"output {input.len}"

main()

# use  -d:release --nimcache:cfile to check c code. 
# looked the c code, have not yet found what's been leaked though, have other things to do, check later.
