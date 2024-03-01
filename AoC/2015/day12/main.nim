import json

proc processJson(value: JsonNode, acc: var int) =
    case value.kind
    of JInt:
        acc += value.num
    of JString, JFloat , JBool:
        discard
    of JArray:
        for i in value:
            processJson(i, acc)
    of JObject:
        for k, v in value.pairs:
            case v.kind
            of JString:
                if v.str == "red":
                    return
            else:
                continue
        for k, v in value.pairs:
            processJson(v, acc)
    else:
        discard


proc main() =

    let jsonStr = readFile("input")
    let jsonData = parseJson(jsonStr)
    var sum = 0
    processJson(jsonData, sum)
    echo "sum: ", sum

main()