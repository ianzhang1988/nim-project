# suggested from nim forum @nrk https://forum.nim-lang.org/t/11094#73250 

import std/[strformat, strutils]

# changed input to openArray[char]
proc findDiffCharIdx(input: openArray[char]): int =
    let first = input[0]
    for i, c in input:
        if c != first:
            return i
    # all the same, diff is len
    return input.len

# gets optimized properly
proc lookAndSay(input: openArray[char], acc: var string) =
    if input.len < 1:
        return
    let idx = findDiffCharIdx(input)
    block: # $idx allocates! so get it to deallocate before the tail call.
      acc &= $idx
    acc &= input[0] # this uses nimAddCharV1, so it's fine to put it outside
    lookAndSay(input.toOpenArray(idx, input.high), acc)

proc main() =
    
    var input = "3113322113"
    
    for i in 0..<50:
        var acc = ""
        lookAndSay(input, acc)
        input = acc
        echo i , " ", input.len
    echo fmt"output {input.len}"

main()