# To keep the Elves busy, Santa has them deliver some presents by hand, door-to-door. He sends them down a street with infinite houses numbered sequentially: 1, 2, 3, 4, 5, and so on.

# Each Elf is assigned a number, too, and delivers presents to houses based on that number:

# The first Elf (number 1) delivers presents to every house: 1, 2, 3, 4, 5, ....
# The second Elf (number 2) delivers presents to every second house: 2, 4, 6, 8, 10, ....
# Elf number 3 delivers presents to every third house: 3, 6, 9, 12, 15, ....
# There are infinitely many Elves, numbered starting with 1. Each Elf delivers presents equal to ten times his or her number at each house.

# So, the first nine houses on the street end up like this:

# House 1 got 10 presents.
# House 2 got 30 presents.
# House 3 got 40 presents.
# House 4 got 70 presents.
# House 5 got 60 presents.
# House 6 got 120 presents.
# House 7 got 80 presents.
# House 8 got 150 presents.
# House 9 got 130 presents.
# The first house gets 10 presents: it is visited only by Elf 1, which delivers 1 * 10 = 10 presents. The fourth house gets 70 presents, because it is visited by Elves 1, 2, and 4, for a total of 10 + 20 + 40 = 70 presents.

# What is the lowest house number of the house to get at least as many presents as the number in your puzzle input?

# Your puzzle input is 34000000.

# The Elves decide they don't want to visit an infinite number of houses. Instead, each Elf will stop after delivering presents to 50 houses. To make up for it, they decide to deliver presents equal to eleven times their number at each house.

# With these changes, what is the new lowest house number of the house to get at least as many presents as the number in your puzzle input?
import math, strformat

let presents_num = 34000000

proc findFactorsV1(n: int): seq[int] =
  var factors: seq[int] = @[]
  for i in 1..int(n/2):
    if n mod i == 0:
      factors.add(i)
  factors.add(n)
  return factors

proc findFactorsV2(n: int): seq[int] =
  var factors: seq[int] = @[]
  var last_l = 0
  var last_r = 0
  for i in 1..n:
    if n mod i == 0:
      last_l = i
      last_r = int(n/i)
      
      if last_l == last_r:
        factors.add(i)
        break

      if last_l > last_r:
        break

      factors.add(i)
      factors.add(last_r)

      
  return factors

# damn, there is a algorithm for this...
proc findFactors(n: int): seq[int] =
  var factors: seq[int] = @[]
  for i in 1..int(sqrt(float64(n))):
    if n mod i == 0:
      factors.add(i)
      let other = n div i
      if i != other:
        factors.add(other)
      
  return factors

proc filterOver50(factors:seq[int], n: int): seq[int] =
  for f in factors:
    if f*50 < n:
      continue
    result.add(f)

proc housePresentNum(houseNum: int): int =
    return sum(findFactors(houseNum)) * 10

proc housePresentNumP2(houseNum: int): int =
    return sum(filterOver50(findFactors(houseNum), houseNum)) * 11

# not good, num do not always increace
proc findHouse() = 
    var i = 1
    while true:
        let num = housePresentNum(i)
        if num >= presents_num:
            break
        # if i mod 1000 == 0:
        #   echo fmt"i:{i}, num: {num}" 
        i+=1

    echo "house: ", i

proc findHouseP2() = 
    var i = 1
    while true:
        let num = housePresentNumP2(i)
        if num >= presents_num:
            break
        # if i mod 1000 == 0:
        #   echo fmt"i:{i}, num: {num}" 
        i+=1

    echo "house: ", i

proc main() =
    # echo int(sqrt(float64(6)))
    # echo findFactors(5)
    echo findFactors(9)
    # echo findFactors(100)
    # echo findFactors(125)
    # echo findFactors(200)
    # echo findFactors(250)
    # echo findFactors(500)
    # echo findFactors(1000)
    echo findFactors(100000000).len
    echo housePresentNum(2259441)
    echo "----------"
    # for i in 1..9:
    #     echo fmt"house[{i}]: {housePresentNum(i)}"
    findHouseP2()
        
main()

