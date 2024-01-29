# A nice string is one with all of the following properties:

# It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
# It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
# It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
# For example:

# ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
# aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
# jchzalrnumimnmhp is naughty because it has no double letter.
# haegwjzuvuyypxyu is naughty because it contains the string xy.
# dvszwmarrgswjxmb is naughty because it contains only one vowel.
import std/strutils

proc isNice(input: string):bool =
    let vowels = @['a', 'e', 'i', 'o', 'u']

    var counter = 0
    for c in input:
        for v in vowels:
            if c == v:
                counter = counter + 1
        if counter >= 3:
            break
    
    if counter < 3:
        return false

    var doubleChar = false
    for i in 0..len(input):
        let i_1 = i + 1
        if i_1 >= len(input):
            break
        if input[i] == input[i_1]:
            doubleChar = true
            break
    
    if not doubleChar:
        return false

    let forbidden = @[ "ab", "cd", "pq", "xy"]
    for f in forbidden:
        if input.contains(f):
            return false

    return true

# Now, a nice string is one with all of the following properties:

# It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
# It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
# For example:

# qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz).
# xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap.
# uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
# ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears twice.

proc isNice2(input: string): bool =
    var found = false
    var firstPair:string

    for i in 0..len(input):
        let i_1 = i + 1
        let leastLeft = i_1+2
        if leastLeft >= len(input):
            break
        firstPair = input[i..i_1]
        if input[(i_1+1)..<len(input)].contains(firstPair):
            found = true
    
    if not found:
        return false

    var repeat = false
    for i in 0..len(input):
        let i_2 = i + 2
        if i_2 >= len(input):
            break
        if input[i] == input[i_2]:
            repeat = true
            break
    if not repeat:
        return false

    return true

proc main() = 

    echo "ugknbfddgicrmopn: ", isNice("ugknbfddgicrmopn")
    echo "aaa: ", isNice("aaa") 
    echo "ugknbfddgicrmopn: ", isNice("jchzalrnumimnmhp") 
    echo "haegwjzuvuyypxyu: ", isNice("haegwjzuvuyypxyu") 
    echo "dvszwmarrgswjxmb: ", isNice("dvszwmarrgswjxmb") 

    let data = readFile("input")
    let strList = data.splitLines()

    var counter = 0
    for s in strList:
        if isNice(s):
            counter = counter + 1
    echo "nice: ", counter

    echo "qjhvhtzxzqqjkmpb: ", isNice2("qjhvhtzxzqqjkmpb")
    echo "xxyxx: ", isNice2("xxyxx") 
    echo "uurcxstgmygtbstg: ", isNice2("uurcxstgmygtbstg") 
    echo "ieodomkazucvgmuy: ", isNice2("ieodomkazucvgmuy")

    counter = 0
    for s in strList:
        if isNice2(s):
            counter = counter + 1
    echo "nice2: ", counter


main()