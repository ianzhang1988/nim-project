# Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so on. Increase the rightmost letter one step; if it was z, it wraps around to a, and repeat with the next letter to the left until one doesn't wrap around.

# Unfortunately for Santa, a new Security-Elf recently started, and he has imposed some additional password requirements:

# Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
# Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are therefore confusing.
# Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.
# For example:

# hijklmmn meets the first requirement (because it contains the straight hij) but fails the second requirement requirement (because it contains i and l).
# abbceffg meets the third requirement (because it repeats bb and ff) but fails the first requirement.
# abbcegjk fails the third requirement, because it only has one double letter (bb).
# The next password after abcdefgh is abcdffaa.
# The next password after ghijklmn is ghjaabcc, because you eventually skip all the passwords that start with ghi..., since i is not allowed.
# Given Santa's current password (your puzzle input), what should his next password be?

# Your puzzle input is hepxcrrq.

import strutils

iterator nextPass(start: string): string =
    var pass = start
    while true:
        var pos = pass.len-1
        
        while true:
            var newCharInt = int8(pass[pos]) + 1
            
            if chr(newCharInt) in @['i', 'o', 'l']:
                pass[pos] = chr(newCharInt)
                continue

            if newCharInt > int8('z'):
                pass[pos] = 'a'
                pos -= 1
                if pos < 0:
                    yield pass
                    break
            else:
                pass[pos] = chr(newCharInt)
                yield pass
                break

func straight3Letter(pass: openArray[char]): bool =
    for pos in pass.low..pass.high-2:
        let l1 = int8(pass[pos])
        let l2 = int8(pass[pos+1])
        let l3 = int8(pass[pos+2])

        if l1+1 == l2 and l2+1 == l3:
            return true

    return false

func twoPairs(pass: openArray[char]): bool =
    var firstPairsPos = -1
    var fisrtChar: char
    for pos in pass.low..pass.high-1:
        if pass[pos] == pass[pos+1]:
            firstPairsPos = pos
            fisrtChar = pass[pos]
            break

    if firstPairsPos < 0:
        return false

    var secondPairsPos = -1
    for pos in (firstPairsPos+2)..pass.high-1:
        if pass[pos] == pass[pos+1]:
            if pass[pos] != fisrtChar:
                secondPairsPos = pos
    if secondPairsPos < 0:
        return false

    return true

proc findNextPass(pass: string): string =
    var counter = 0
    for p in nextPass(pass):
        # counter += 1
        # if counter > 10:
        #     break
        
        if not straight3Letter(p):
            continue
        if not twoPairs(p):
            continue

        
        return p

proc main() =

    let pass = findNextPass("hepxcrrq")
    echo pass
    echo findNextPass(pass)

main()