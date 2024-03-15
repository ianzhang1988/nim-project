# For example, imagine a simpler machine that supports only the following replacements:

# H => HO
# H => OH
# O => HH
# Given the replacements above and starting with HOH, the following molecules could be generated:

# HOOH (via H => HO on the first H).
# HOHO (via H => HO on the second H).
# OHOH (via H => OH on the first H).
# HOOH (via H => OH on the second H).
# HHHH (via O => HH).
# So, in the example above, there are 4 distinct molecules (not five, because HOOH appears twice) after one replacement from HOH. Santa's favorite molecule, HOHOHO, can become 7 distinct molecules (over nine replacements: six from H, and three from O).

# The machine replaces without regard for the surrounding characters. For example, given the string H2O, the transition H => OO would result in OO2O.

# Your puzzle input describes all of the possible replacements and, at the bottom, the medicine molecule for which you need to calibrate the machine. How many distinct molecules can be created after all the different ways you can do one replacement on the medicine molecule?

# part 2
# Molecule fabrication always begins with just a single electron, e, and applying replacements one at a time, just like the ones during calibration.

# For example, suppose you have the following replacements:

# e => H
# e => O
# H => HO
# H => OH
# O => HH
# If you'd like to make HOH, you start with e, and then make the following replacements:

# e => O to get O
# O => HH to get HH
# H => OH (on the second H) to get HOH
# So, you could make HOH after 3 steps. Santa's favorite molecule, HOHOHO, can be made in 6 steps.

# How long will it take to make the medicine? Given the available replacements and the medicine molecule in your puzzle input, what is the fewest number of steps to go from e to the medicine molecule?

import strutils, sequtils, sets, algorithm, tables, strformat

let inputTest="""H => HO
H => OH
O => HH
e => H
e => O

HOHHOHOHOO""" # 10

proc parse(input: string): (seq[(string, string)], string) =
    let lines = input.splitLines()
    
    var replacements:seq[(string, string)]

    for l in lines[0..^3]:
        # echo "l:", l
        let parts = l.split(" ")
        replacements.add((parts[0], parts[2]))

    let molecule = lines[^1]

    return (replacements, molecule)

proc findReplacements(replacements: seq[(string, string)], fromInput: string): (seq[string],bool) =
    var found = false
    var toSeq: seq[string]
    for r in replacements:
        let (`from`, to) = r
        if fromInput == `from`:
            found = true
            toSeq.add(to)
    
    return (toSeq, found)

proc part1(replacements:seq[(string, string)], molecule: string) =
    var newMolecle: HashSet[string]
    var pos = 0
    while pos < molecule.len:
        let m1 = $molecule[pos]
        let (toSeq, found) = findReplacements(replacements, m1)
        if found:
            for to in toSeq:
                newMolecle.incl( molecule[0..pos-1] & to & molecule[pos+1..^1])

            pos += 1
            continue

        #
        if pos + 1 < molecule.len:
            let m2 = molecule[pos..pos+1]
            let (toSeq, found) = findReplacements(replacements, m2)
            if found:
                for to in toSeq:
                    newMolecle.incl(molecule[0..pos-1] & to & molecule[pos+2..^1])

                pos += 2
                continue
        
        pos += 1

    # echo newMolecle

    echo "num: ", newMolecle.len()

# not work
proc part2_1(replacements:seq[(string, string)], molecule: string) =
    var moleculeToReduce = molecule

    var replacementsSorted = replacements

    func myCmp(x:(string, string), y:(string, string)): int =
        let (_, xto) = x
        let (_, yto) = y
        return xto.len - yto.len

    # long one is in front
    sort(replacementsSorted, myCmp, SortOrder.Descending)
    # echo replacementsSorted

    var counter = 0
    while moleculeToReduce != "e":
        for (`from`, to) in replacementsSorted:
            echo "1:", moleculeToReduce
            let num = moleculeToReduce.count(to)
            if num >= 0:
                counter += num
                moleculeToReduce = moleculeToReduce.replace(to, `from`)
            echo "2:", moleculeToReduce

    echo "num: ", counter

proc backtarceMolecule(cache: var Table[string, int], replacements: seq[(string, string)], molecule: string): int =
    # echo fmt"debug {molecule} {depth}" 

    if molecule == "e":
        return 0

    if cache.contains(molecule):
        return cache[molecule]

    var depthSeq:seq[int]

    for (`from`, to) in replacements:
        var pos = 0

        while true:
            let idx = molecule.find(to, pos)
            if idx < 0:
                break

            pos = idx + to.len
            
            let nextMolecule = molecule[0..idx-1] & `from` & molecule[idx + to.len..^1]

            # echo nextMolecule
            let short = backtarceMolecule(cache, replacements, nextMolecule)
            depthSeq.add(short)
            
    if depthSeq.len == 0 or max(depthSeq) < 0:
        cache[molecule]= -1
        return -1

    let newDepth = depthSeq.filterIt(it >= 0)
    # echo fmt"debug2 {molecule} {newDepth} {cache}" 
    cache[molecule] = min(newDepth) + 1
    return min(newDepth) + 1

proc part2(replacements:seq[(string, string)], molecule: string) =
    # backtracing the steps
    var cache: Table[string, int]
    let shortest = backtarceMolecule(cache, replacements, molecule)
    echo "cache num:", cache.len
    echo "num: ", shortest

proc main() =
    let input = readFile("input")
    var (replacements, molecule) = parse(inputTest)
    # part1(replacements, molecule)
    part2(replacements, molecule)

main()

