# In this game, the player (you) and the enemy (the boss) take turns attacking. The player always goes first. Each attack reduces the opponent's hit points by at least 1. The first character at or below 0 hit points loses.

# Damage dealt by an attacker each turn is equal to the attacker's damage score minus the defender's armor score. An attacker always does at least 1 damage. So, if the attacker has a damage score of 8, and the defender has an armor score of 3, the defender loses 5 hit points. If the defender had an armor score of 300, the defender would still lose 1 hit point.

# Your damage score and armor score both start at zero. They can be increased by buying items in exchange for gold. You start with no items and have as much gold as you need. Your total damage or armor is equal to the sum of those stats from all of your items. You have 100 hit points.

# Here is what the item shop is selling:

# Weapons:    Cost  Damage  Armor
# Dagger        8     4       0
# Shortsword   10     5       0
# Warhammer    25     6       0
# Longsword    40     7       0
# Greataxe     74     8       0

# Armor:      Cost  Damage  Armor
# Leather      13     0       1
# Chainmail    31     0       2
# Splintmail   53     0       3
# Bandedmail   75     0       4
# Platemail   102     0       5

# Rings:      Cost  Damage  Armor
# Damage +1    25     1       0
# Damage +2    50     2       0
# Damage +3   100     3       0
# Defense +1   20     0       1
# Defense +2   40     0       2
# Defense +3   80     0       3
# You must buy exactly one weapon; no dual-wielding. Armor is optional, but you can't use more than one. You can buy 0-2 rings (at most one for each hand). You must use any items you buy. The shop only has one of each item, so you can't buy, for example, two rings of Damage +3.

# For example, suppose you have 8 hit points, 5 damage, and 5 armor, and that the boss has 12 hit points, 7 damage, and 2 armor:

# The player deals 5-2 = 3 damage; the boss goes down to 9 hit points.
# The boss deals 7-5 = 2 damage; the player goes down to 6 hit points.
# The player deals 5-2 = 3 damage; the boss goes down to 6 hit points.
# The boss deals 7-5 = 2 damage; the player goes down to 4 hit points.
# The player deals 5-2 = 3 damage; the boss goes down to 3 hit points.
# The boss deals 7-5 = 2 damage; the player goes down to 2 hit points.
# The player deals 5-2 = 3 damage; the boss goes down to 0 hit points.
# In this scenario, the player wins! (Barely.)

# You have 100 hit points. The boss's actual stats are in your puzzle input. What is the least amount of gold you can spend and still win the fight?

# Hit Points: 103
# Damage: 9
# Armor: 2

import strutils, math 

type
    Character = object
        HP: int
        Damage: int
        Armor: int
    Item = object
        Cost: int
        Damage: int
        Armor: int


# proc attack(self, target: var Character) = 
#     var deelDamage = self.Damage - target.Armor
#     if deelDamage < 1:
#         deelDamage = 1
#     target.HP -= deelDamage
proc fight(self, target: var Character): bool = 
    var deelDamage = self.Damage - target.Armor
    if deelDamage < 1:
        deelDamage = 1
    var receiveDamage = target.Damage - self.Armor
    if receiveDamage < 1:
        receiveDamage = 1
    # let selfTurn = ceil(self.HP / receiveDamage)
    let targetTrun = ceil(target.HP / deelDamage)
    #echo self.HP - receiveDamage*int(targetTrun-1)
    return self.HP - receiveDamage*int(targetTrun-1) > 0

let weaponsData = """Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0"""
let armorsData = """Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5"""
let ringsData = """Damage+1    25     1       0
Damage+2    50     2       0
Damage+3   100     3       0
Defense+1   20     0       1
Defense+2   40     0       2
Defense+3   80     0       3"""

proc parseItem(data: string): seq[Item] =
    let lines = data.splitLines()
    for l in lines:
        let parts = l.splitWhitespace()
        result.add(Item(
            Cost: parts[1].parseInt(),
            Damage: parts[2].parseInt(),
            Armor: parts[3].parseInt()
        ))

proc main() =
    var testBoss = Character(
        HP: 12,
        Damage: 7,
        Armor: 2
    )
    var testPlayer = Character(
        HP: 8,
        Damage: 5,
        Armor: 5
    )
    echo testPlayer.fight(testBoss)
    var boss = Character(
        HP: 103,
        Damage: 9,
        Armor: 2
    )
    var player = Character(
        HP: 100,
        Damage: 0,
        Armor: 0
    )
    let dummyItem = Item()
    let weapons = parseItem(weaponsData)
    var armors = parseItem(armorsData)
    armors.add(dummyItem)
    var rings = parseItem(ringsData)
    rings.add(dummyItem)
    rings.add(dummyItem)

    echo weapons
    echo armors
    echo rings

    var lowCost = 10000
    var highCost = 0
    var last: (int, int, int, int)

    for w in weapons:
        for a in armors:
            for i,r in rings:
                let rest = rings[0..i-1] & rings[i+1..^1]
                for r2 in rest:
                    player.Damage = w.Damage + a.Damage + r.Damage + r2.Damage
                    player.Armor = w.Armor + a.Armor + r.Armor + r2.Armor
                    let cost = w.Cost + a.Cost + r.Cost + r2.Cost
                    if player.fight(boss):
                        if lowCost > cost:
                            lowCost = cost
                    if not player.fight(boss):
                        if highCost < cost:
                            highCost = cost
                            last = (w.Cost ,a.Cost, r.Cost, r2.Cost)

    echo "lowest:", lowCost
    echo "highest:", highCost
    echo last

main()