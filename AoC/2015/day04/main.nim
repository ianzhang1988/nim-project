# import src/checksums/md5
import checksums/md5
import std/strformat

proc gen_coin(key: string, k: int): int = 
    var i = 0
    let kk = k - 1

    var matchStr = ""
    for _ in 0..<k:
        matchStr = matchStr & "0"

    while true:
        var md5Data = key & fmt"{i}"
        let md5Str = $(md5Data.toMD5())

        if md5Str[0..kk] == matchStr:
            break

        i+=1

        if i.mod(1000000) == 0:
            echo(i)

    return i

proc main() = 

    var data = "abcdef609043"
    echo data.toMD5()
    let coinCheck = gen_coin("abcdef", 5)
    echo 609043, "?=", coinCheck, " ", coinCheck == 609043

    let key = "ckczppom"
    let coin = gen_coin(key, 6)
    echo "coin: ", coin

main()
