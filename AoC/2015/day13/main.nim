import sequtils, tables, strutils

let testSample = """Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol."""

let score = 330

proc backtrackPermutations[T](result: var seq[seq[T]], current: seq[T], remaining: seq[T]) =
    if remaining.len == 0:
        result.add(current)
    else:
        for i in remaining:
            let newCurrent = current & i
            let remain = remaining.filterIt(it != i)
            backtrackPermutations(result, newCurrent, remain)
 
proc permutations[T](seq: seq[T]): seq[seq[T]] =
    backtrackPermutations(result, @[], seq)
    return

type Preference = object
    me: string
    score: int
    other: string

proc parsLine(line: string): Preference =
    let parts = line.split(" ")
    var score = 0
    if parts[2] == "gain":
        score = parts[3].parseInt()
    else:
        score = -parts[3].parseInt()

    return Preference(me:parts[0], score:score, other: parts[10][0..^2])

proc parseInput(data: string):Table[string, Preference] =
    for l in data.splitLines():
        let p = parsLine(l)
        result[p.me & "_" & p.other] = p

proc parsePeople(data: string): seq[string] =
    for l in data.splitLines():
        let p = parsLine(l)
        if p.me notin result:
            result.add(p.me)

proc calculateScore(sequence: seq[string], preference:Table[string, Preference] ): int = 
    var score = 0
    let extendSeq = sequence[^1] & sequence & sequence[0]

    for i in 1..<(extendSeq.len - 1):
        let me = extendSeq[i]
        let lhs = extendSeq[i-1]
        let rhs = extendSeq[i+1]
        let lhs_preference = preference[me & "_" & lhs].score
        let rhs_preference = preference[me & "_" & rhs].score
        score += lhs_preference
        score += rhs_preference

    return score

proc main() = 
    # echo permutations(@[1,2,3])
    let input = readFile("input")
    var preference = parseInput(input)
    var people = parsePeople(input)

    echo "people: ", people
    
    for p in people:
        preference[p & "_" & "myself"] = Preference(me:p, score:0, other: "myself")
        preference["myself" & "_" & p] = Preference(me:"myself", score:0, other: p)

    people.add("myself")

    let seatSeq = permutations(people)

    var highestScore = 0
    for s in seatSeq:
        let newScore = calculateScore(s, preference)
        if newScore > highestScore:
            highestScore = newScore
    echo "score: ", highestScore

main()