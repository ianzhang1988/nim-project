# For example:

# "" is 2 characters of code (the two double quotes), but the string contains zero characters.
# "abc" is 5 characters of code, but 3 characters in the string data.
# "aaa\"aaa" is 10 characters of code, but the string itself contains six "a" characters and a single, escaped quote character, for a total of 7 characters in the string data.
# "\x27" is 6 characters of code, but the string itself contains just one - an apostrophe ('), escaped using hexadecimal notation.
# Santa's list is a file that contains many double-quoted string literals, one on each line. The only escape sequences used are \\ (which represents a single backslash), \" (which represents a lone double-quote character), and \x plus two hexadecimal characters (which represents a single character with that ASCII code).

# Disregarding the whitespace in the file, what is the number of characters of code for string literals minus the number of characters in memory for the values of the strings in total for the entire file?
# For example, given the four strings above, the total number of characters of string code (2 + 5 + 10 + 6 = 23) minus the total number of characters in memory for string values (0 + 3 + 7 + 1 = 11) is 23 - 11 = 12.

import std/strformat
import strutils

proc doParse(representation: string): string =
    let firstChar = representation[0]

    case firstChar
    of '"':
        return
    of 'a'..'z', 'A'..'Z':
        return firstChar & doParse(representation[1..^1])
    of '\\':
        let follow = representation[1]
        case follow
        of '"', '\\':
            return follow & doParse(representation[2..^1])
        of 'x':
            let numStr = representation[2..3]
            let num = numStr.parseHexInt()
            return num.chr & doParse(representation[4..^1])
        else:
            return
    else:
        return

proc parse(representation: string): string =
    # discard first "
    return doParse(representation[1..^1])

# For example:

# "" encodes to "\"\"", an increase from 2 characters to 6.
# "abc" encodes to "\"abc\"", an increase from 5 characters to 9.
# "aaa\"aaa" encodes to "\"aaa\\\"aaa\"", an increase from 10 characters to 16.
# "\x27" encodes to "\"\\x27\"", an increase from 6 characters to 11.
# Your task is to find the total number of characters to represent the newly encoded strings minus the number of characters of code in each original string literal. For example, for the strings above, the total encoded length (6 + 9 + 16 + 11 = 42) minus the characters in the original code representation (23, just like in the first part of this puzzle) is 42 - 23 = 19.

proc encode(characters: string) :string =
    if characters.len < 1:
        return

    let firstChar = characters[0]
    
    case firstChar
    of 'a'..'z', 'A'..'Z', '0'..'9':
        return firstChar & encode(characters[1..^1])
    of '"':
        return "\\\"" & encode(characters[1..^1])
    of '\\':
        return "\\\\" & encode(characters[1..^1])
    else:
        return

proc main() = 
    
    var characters = """"aaa\"aaa""""
    echo characters
    echo parse(characters)
    characters = """"abc""""
    echo characters
    echo parse(characters)
    characters = """"\x27""""
    echo characters
    echo parse(characters)

    echo "-----------------"

    let data = readFile("input")
    let strList = data.splitLines()

    var charactersNum = 0
    var memoryNum = 0
    for str in strList:
        charactersNum += str.len
        memoryNum += str.parse.len

    echo "charactersNum: ", charactersNum
    echo "memoryNum: ", memoryNum
    echo "diff: ", charactersNum - memoryNum

    echo "-----------------"
    charactersNum = 0
    var encodeNum = 0
    characters = """"aaa\"aaa""""
    echo characters
    echo encode(characters)
    charactersNum += characters.len
    encodeNum += characters.encode.len
    characters = """"abc""""
    echo characters
    echo encode(characters)
    charactersNum += characters.len
    encodeNum += characters.encode.len
    characters = """"\x27""""
    echo characters
    echo encode(characters)
    charactersNum += characters.len
    encodeNum += characters.encode.len
    characters = """"""""
    echo characters
    echo encode(characters)
    charactersNum += characters.len
    encodeNum += characters.encode.len

    echo "charactersNum: ", charactersNum
    # add ""
    echo "encodeNum: ", encodeNum + 2 + 2 + 2 + 2
    

    echo "-----------------"
    
    charactersNum = 0
    var representationNum = 0
    for str in strList:
        charactersNum += str.len
        representationNum += str.encode.len + 2

    echo "charactersNum: ", charactersNum
    echo "representationNum: ", representationNum
    echo "diff: ", representationNum - charactersNum


main()