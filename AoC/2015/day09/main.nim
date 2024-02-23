# This year, however, he has some new locations to visit; his elves have provided him the distances between every pair of locations. He can start and end at any two (different) locations he wants, but he must visit each location exactly once. What is the shortest distance he can travel to achieve this?

# For example, given the following distances:

# London to Dublin = 464
# London to Belfast = 518
# Dublin to Belfast = 141
# The possible routes are therefore:

# Dublin -> London -> Belfast = 982
# London -> Dublin -> Belfast = 605
# London -> Belfast -> Dublin = 659
# Dublin -> Belfast -> London = 659
# Belfast -> Dublin -> London = 605
# Belfast -> London -> Dublin = 982
# The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.

# What is the distance of the shortest route?

import sequtils, strutils, strformat, tables

proc backtrackPermutations[T](result: var seq[seq[T]], current: seq[T], remaining: seq[T]) =
  if remaining.len == 0:
    result.add(current)
  else:
    for elem in remaining:
      var nextCurrent = current & @[elem]
      var nextRemaining = remaining.filterIt(it != elem)
      backtrackPermutations(result, nextCurrent, nextRemaining)

proc permutations[T](seq: seq[T]): seq[seq[T]] =
  backtrackPermutations(result, @[], seq)
  return

# Example usage:
# let seq = @[1, 2, 3]
# let perms = permutations(seq)
# for perm in perms:
#   echo perm

proc parse(line:string): (string, string, int) =
    # London to Dublin = 464
    let parts = line.split(" ")
    return (parts[0], parts[2], parts[4].parseInt())


proc main() =
    let data = readFile("input")
    let strList = data.splitLines()

    var loc: seq[string] = @[]
    var distanceMap: Table[(string, string), int]

    for l in strList:
        let (loc1, loc2, distance) = parse(l)
        # echo fmt"{loc1} {loc2} {distance}"
        if loc1 notin loc:
            loc.add(loc1)
        if loc2 notin loc:
            loc.add(loc2)
        distanceMap[(loc1, loc2)] = distance
        distanceMap[(loc2, loc1)] = distance
    
    echo "loc: ", loc
    # echo "distanceMap: ", distanceMap

    let allPath = permutations(loc)
    echo "allPath len: ", allPath.len

    var shortest = -1
    var longest = 0
    for path in allPath:
        var pathLen = 0
        for iLoc in 0..<(path.len-1):
            let loc1 = path[iLoc]
            let loc2 = path[iLoc+1]
            if (loc1, loc2) in distanceMap:
                pathLen += distanceMap[(loc1, loc2)]
            else:
                pathLen = -1
        
        if pathLen>0:
            if shortest < 0:
                shortest = pathLen
            else:
                if pathLen < shortest:
                    shortest = pathLen

            if longest < pathLen:
                longest = pathLen

    echo "shoutest: ", shortest
    echo "longest: ", longest

main()