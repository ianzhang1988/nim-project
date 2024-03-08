# For instance, suppose you have these two ingredients:

# Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
# Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
# Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of cinnamon (because the amounts of each ingredient must add up to 100) would result in a cookie with the following properties:

# A capacity of 44*-1 + 56*2 = 68
# A durability of 44*-2 + 56*3 = 80
# A flavor of 44*6 + 56*-2 = 152
# A texture of 44*3 + 56*-1 = 76
# Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results in a total score of 62842880, which happens to be the best score possible given these ingredients. If any properties had produced a negative total, it would have instead become zero, causing the whole score to multiply to zero.

import strformat, strutils
import regex

proc backtarckCombination(output: var seq[seq[int]], combination: seq[int], limit:int, num:int) =
    if num == 1:
        let newCombination = combination & limit
        output.add(newCombination)
        return

    for i in 0..limit:
        let newCombination = combination & i
        backtarckCombination(output, newCombination, limit - i, num - 1)

proc combination(limit: int, num: int): seq[seq[int]] = 
    let combination:seq[int] = @[]
    backtarckCombination(result, combination, limit, num)

type
    Ingredient = object
        name: string
        capacity: int
        durability: int
        flavor: int
        texture: int
        calories: int

proc parseInput(input: string): seq[Ingredient] =
    let lines = input.splitLines()
    for l in lines:
        # Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
        var m: RegexMatch2
        if l.find(re2"(\w+): \w+ (-??\d+), \w+ (-??\d+), \w+ (-??\d+), \w+ (-??\d+), \w+ (-??\d+)", m):
            echo "name: ", l[m.group(0)]
            let i = Ingredient(
                name: l[m.group(0)],
                capacity: l[m.group(1)].parseInt(),
                durability: l[m.group(2)].parseInt(),
                flavor: l[m.group(3)].parseInt(),
                texture: l[m.group(4)].parseInt(),
                calories: l[m.group(5)].parseInt(),
            )
            echo i
            result.add(i)
        else:
            echo "parse input err"

proc main() =
    
    let testInput = """Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"""
    let data = readFile("input")
    let ingredients = parseInput(data)
    # for i in ingredients:
    #     echo i

    let comb = combination(100, ingredients.len)
    echo fmt"len(comb): {len(comb)}"

    var highest = 0
    var lastComb: seq[int]
    for c in comb:
        var capacity = 0
        var durability = 0
        var flavor = 0
        var texture = 0
        var calories = 0
        for i in 0..<ingredients.len:
            capacity += c[i]*ingredients[i].capacity
            durability += c[i]*ingredients[i].durability
            flavor += c[i]*ingredients[i].flavor
            texture += c[i]*ingredients[i].texture
            calories += c[i]*ingredients[i].calories
        var score =  capacity * durability * flavor * texture
        if min(capacity, min(durability, min(flavor, texture))) < 1:
            score = 0
        if calories == 500 and score > highest:
            lastComb = c
            highest = score

    echo "comb", lastComb
    echo "highest: ", highest

main()