# children: 3
# cats: 7
# samoyeds: 2
# pomeranians: 3
# akitas: 0
# vizslas: 0
# goldfish: 5
# trees: 3
# cars: 2
# perfumes: 1
# You make a list of the things you can remember about each Aunt Sue. Things missing from your list aren't zero - you simply don't remember the value.

# What is the number of the Sue that got you the gift?

import strutils, regex

type
    AuntSue = object
        name: string
        children: int
        cats: int
        samoyeds: int
        pomeranians: int
        akitas: int
        vizslas: int
        goldfish: int
        trees: int
        cars: int
        perfumes: int

func initAuntSue(): AuntSue = 
    return AuntSue(
        children: -1,
        cats: -1,
        samoyeds: -1,
        pomeranians: -1,
        akitas: -1,
        vizslas: -1,
        goldfish: -1,
        trees: -1,
        cars: -1,
        perfumes: -1,
    )

func set(aunt: var AuntSue, property: string, value: int) =
    case property
    of "children":
        aunt.children = value
    of "cats":
        aunt.cats = value
    of "samoyeds":
        aunt.samoyeds = value
    of "pomeranians":
        aunt.pomeranians = value
    of "akitas":
        aunt.akitas = value
    of "vizslas":
        aunt.vizslas = value
    of "goldfish":
        aunt.goldfish = value
    of "trees":
        aunt.trees = value
    of "cars":
        aunt.cars = value
    of "perfumes":
        aunt.perfumes = value

# Sue 1: cars: 9, akitas: 3, goldfish: 0
# Sue 2: akitas: 9, children: 3, samoyeds: 9
proc parseInput(input: string) : seq[AuntSue] = 
    let lines = input.splitLines()
    for l in lines:
        var m: RegexMatch2
        if l.find(re2"Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)", m):
            let name = l[m.group(0)]
            # echo "name: ", name
            let p1 = l[m.group(1)]
            let p1v = l[m.group(2)].parseInt()
            let p2 = l[m.group(3)]
            let p2v = l[m.group(4)].parseInt()
            let p3 = l[m.group(5)]
            let p3v = l[m.group(6)].parseInt()
            
            var aunt = initAuntSue()
            aunt.name = name
            aunt.set(p1, p1v)
            aunt.set(p2, p2v)
            aunt.set(p3, p3v)
            # echo aunt
            result.add(aunt)
        else:
            echo "parse input err"

template compare(match: untyped, a1: untyped, a2: untyped, prop: untyped) =
    if a1.prop != -1:
        if a1.prop != a2.prop:
            match = match and false

proc part1(aunts: seq[AuntSue], auntReading: AuntSue) =
    for a in aunts:
        var match = true
        compare(match, a, auntReading, children)
        compare(match, a, auntReading, cats)
        compare(match, a, auntReading, samoyeds)
        compare(match, a, auntReading, pomeranians)
        compare(match, a, auntReading, akitas)
        compare(match, a, auntReading, vizslas)
        compare(match, a, auntReading, goldfish)
        compare(match, a, auntReading, trees)
        compare(match, a, auntReading, cars)
        compare(match, a, auntReading, perfumes)
        if match:
            echo a

# In particular, the cats and trees readings indicates that there are greater than that many 
# (due to the unpredictable nuclear decay of cat dander and tree pollen), 
# while the pomeranians and goldfish readings indicate that there are fewer than that many
# (due to the modial interaction of magnetoreluctance).

template greater(match: untyped, a1: untyped, a2: untyped, prop: untyped) =
    if a1.prop != -1:
        if a1.prop <= a2.prop:
            match = match and false

template fewer(match: untyped, a1: untyped, a2: untyped, prop: untyped) =
    if a1.prop != -1:
        if a1.prop >= a2.prop:
            match = match and false

proc part2(aunts: seq[AuntSue], auntReading: AuntSue) =
    for a in aunts:
        var match = true
        compare(match, a, auntReading, children)
        greater(match, a, auntReading, cats)
        compare(match, a, auntReading, samoyeds)
        fewer(match, a, auntReading, pomeranians)
        compare(match, a, auntReading, akitas)
        compare(match, a, auntReading, vizslas)
        fewer(match, a, auntReading, goldfish)
        greater(match, a, auntReading, trees)
        compare(match, a, auntReading, cars)
        compare(match, a, auntReading, perfumes)
        if match:
            echo a

proc main() =
    let data = readFile("input")
    let aunts = parseInput(data)

    let auntReading = AuntSue(
            children: 3,
            cats: 7,
            samoyeds: 2,
            pomeranians: 3,
            akitas: 0,
            vizslas: 0,
            goldfish: 5,
            trees: 3,
            cars: 2,
            perfumes: 1,
        )

    echo "part1:"
    part1(aunts, auntReading)
    echo "part2:"
    part2(aunts, auntReading)

main()