# In this version, combat still proceeds with the player and the boss taking alternating turns. The player still goes first. Now, however, you don't get any equipment; instead, you must choose one of your spells to cast. The first character at or below 0 hit points loses.

# Since you're a wizard, you don't get to wear armor, and you can't attack normally. However, since you do magic damage, your opponent's armor is ignored, and so the boss effectively has zero armor as well. As before, if armor (from a spell, in this case) would reduce damage below 1, it becomes 1 instead - that is, the boss' attacks always deal at least 1 damage.

# On each of your turns, you must select one of your spells to cast. If you cannot afford to cast any spell, you lose. Spells cost mana; you start with 500 mana, but have no maximum limit. You must have enough mana to cast a spell, and its cost is immediately deducted when you cast it. Your spells are Magic Missile, Drain, Shield, Poison, and Recharge.

# Magic Missile costs 53 mana. It instantly does 4 damage.
# Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
# Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
# Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
# Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
# Effects all work the same way. Effects apply at the start of both the player's turns and the boss' turns. Effects are created with a timer (the number of turns they last); at the start of each turn, after they apply any effect they have, their timer is decreased by one. If this decreases the timer to zero, the effect ends. You cannot cast a spell that would start an effect which is already active. However, effects can be started on the same turn they end.

# For example, suppose the player has 10 hit points and 250 mana, and that the boss has 13 hit points and 8 damage:

# -- Player turn --
# - Player has 10 hit points, 0 armor, 250 mana
# - Boss has 13 hit points
# Player casts Poison.

# -- Boss turn --
# - Player has 10 hit points, 0 armor, 77 mana
# - Boss has 13 hit points
# Poison deals 3 damage; its timer is now 5.
# Boss attacks for 8 damage.

# -- Player turn --
# - Player has 2 hit points, 0 armor, 77 mana
# - Boss has 10 hit points
# Poison deals 3 damage; its timer is now 4.
# Player casts Magic Missile, dealing 4 damage.

# -- Boss turn --
# - Player has 2 hit points, 0 armor, 24 mana
# - Boss has 3 hit points
# Poison deals 3 damage. This kills the boss, and the player wins.





# Now, suppose the same initial conditions, except that the boss has 14 hit points instead:

# 0-- Player turn --
# - Player has 10 hit points, 0 armor, 250 mana
# - Boss has 14 hit points
# Player casts Recharge.

# 1-- Boss turn --
# - Player has 10 hit points, 0 armor, 21 mana
# - Boss has 14 hit points
# Recharge provides 101 mana; its timer is now 4.
# Boss attacks for 8 damage!

# 2-- Player turn --
# - Player has 2 hit points, 0 armor, 122 mana
# - Boss has 14 hit points
# Recharge provides 101 mana; its timer is now 3.
# Player casts Shield, increasing armor by 7.

# 3-- Boss turn --
# - Player has 2 hit points, 7 armor, 110 mana
# - Boss has 14 hit points
# Shield's timer is now 5.
# Recharge provides 101 mana; its timer is now 2.
# Boss attacks for 8 - 7 = 1 damage!

# 4-- Player turn --
# - Player has 1 hit point, 7 armor, 211 mana
# - Boss has 14 hit points
# Shield's timer is now 4.
# Recharge provides 101 mana; its timer is now 1.
# Player casts Drain, dealing 2 damage, and healing 2 hit points.

# 5-- Boss turn --
# - Player has 3 hit points, 7 armor, 239 mana
# - Boss has 12 hit points
# Shield's timer is now 3.
# Recharge provides 101 mana; its timer is now 0.
# Recharge wears off.
# Boss attacks for 8 - 7 = 1 damage!

# 6-- Player turn --
# - Player has 2 hit points, 7 armor, 340 mana
# - Boss has 12 hit points
# Shield's timer is now 2.
# Player casts Poison.

# 7-- Boss turn --
# - Player has 2 hit points, 7 armor, 167 mana
# - Boss has 12 hit points
# Shield's timer is now 1.
# Poison deals 3 damage; its timer is now 5.
# Boss attacks for 8 - 7 = 1 damage!

# 8-- Player turn --
# - Player has 1 hit point, 7 armor, 167 mana
# - Boss has 9 hit points
# Shield's timer is now 0.
# Shield wears off, decreasing armor by 7.
# Poison deals 3 damage; its timer is now 4.
# Player casts Magic Missile, dealing 4 damage.

# 9-- Boss turn --
# - Player has 1 hit point, 0 armor, 114 mana
# - Boss has 2 hit points
# Poison deals 3 damage. This kills the boss, and the player wins.
# You start with 50 hit points and 500 mana points. The boss's actual stats are in your puzzle input. What is the least amount of mana you can spend and still win the fight? (Do not include mana recharge effects as "spending" negative mana.)

# Hit Points: 55
# Damage: 8

import sequtils

type
    Character = object
        HP: int
        mana: int
        armor: int
        damage: int
        effect: seq[Effect]
        usedMana: int
    MagicType = enum
        Missile, Drain, Shield, Poison, Recharge
    Magic = object of RootObj
        magicType: MagicType
        cost: int
        damage: int
        heal: int
        last: int
        armor: int
        mana: int
    Effect = object of Magic
        endTurn: int


# Magic Missile costs 53 mana. It instantly does 4 damage.
# Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
# Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
# Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
# Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
let missile = Magic(magicType: Missile, cost: 53, damage: 4)
let drain = Magic(magicType: Drain, cost: 73, damage: 2, heal: 2)
let shield = Magic(magicType: Shield, cost: 113, armor: 7, last: 6)
let poison = Magic(magicType: Poison, cost: 173, damage: 3, last: 6)
let recharge = Magic(magicType: Recharge, cost: 229, damage: 0, last: 5, mana: 101)

proc castMagic(player: Character, boss: Character, magic: Magic, currentTurn: int): (Character, Character) =
    var playerNext = player
    var bossNext = boss
    if playerNext.mana < magic.cost:
        return (playerNext, bossNext)
    playerNext.mana -= magic.cost
    playerNext.usedMana += magic.cost
    case magic.magicType:
    of Missile, Drain:
        playerNext.HP += magic.heal
        bossNext.HP -= magic.damage
    of Shield, Recharge:
        playerNext.armor += magic.armor
        var effect: Effect = cast[Effect](magic)
        effect.endTurn = currentTurn + magic.last
        playerNext.effect.add(effect)
    of Poison:
        var effect: Effect = cast[Effect](magic)
        effect.endTurn = currentTurn + magic.last
        bossNext.effect.add(effect)
    return (playerNext, bossNext)

proc attack(player: Character, boss: Character): (Character, Character) =
    var playerNext = player
    var damage = boss.damage - player.armor
    if damage < 1:
        damage = 1
    playerNext.HP -= damage
    return (playerNext, boss)

proc applyEffect(character: var Character, currentTurn: int) =
    # let validEffect = character.effect.filterIt(it.endTurn != currentTurn)
    # let wearsOffShield = character.effect.filterIt(it.endTurn == currentTurn and it.magicType == Shield)
    # if wearsOffShield.len > 0:
    #     character.armor = 0

    # here I got messed up with the timing, old code may miss timing the effect.
    # in describtion, apply effect then decrease timer, my old code decrease timer then apply effect.
    
    for e in character.effect:
        case e.magicType:
        of Recharge:
            character.mana += e.mana
        of Poison:
            character.HP -= e.damage
        else:
            discard

    let validEffect = character.effect.filterIt(it.endTurn != currentTurn)
    let wearsOffShield = character.effect.filterIt(it.endTurn == currentTurn and it.magicType == Shield)
    if wearsOffShield.len > 0:
        character.armor = 0

    character.effect = validEffect

proc magicActive(magic: MagicType, player: Character, boss: Character) :bool =
    for e in player.effect:
        if e.magicType == magic:
            return true
    for e in boss.effect:
        if e.magicType == magic:
            return true

proc testPlay() =
# For example, suppose the player has 10 hit points and 250 mana, and that the boss has 13 hit points and 8 damage:
    var player = Character(HP:10, mana: 250)
    var boss = Character(HP:14, damage: 8)

    var turn = 0

    proc helper(magic: Magic) =
        if turn mod 2 == 0:
            # player turn
            echo turn, "--- player trun ----------------------"
        else:
            echo turn, "--- boss trun ------------------------"

        echo "player:", player
        echo "boss:", boss
        applyEffect(player, turn)
        applyEffect(boss, turn)
        echo "--- effect ---"
        echo "player:", player
        echo "boss:", boss
        if turn mod 2 == 0:
            # player turn
            (player, boss) = castMagic(player, boss, magic, turn)
        else:
            (player, boss) = attack(player, boss)
        # echo "player:", player
        # echo "boss:", boss

    helper(recharge)
    turn += 1
    helper(Magic())
    turn += 1
    helper(shield)
    turn += 1
    helper(Magic())
    turn += 1
    helper(drain)
    turn += 1
    helper(Magic())
    turn += 1
    helper(poison)
    turn += 1
    helper(Magic())
    turn += 1
    helper(missile)
    turn += 1
    helper(Magic())
    turn += 1

    echo "mana used:", player.usedMana

proc testPlay2() =
    var player = Character(HP:50, mana: 500)
    var boss = Character(HP:55, damage: 8)

    var turn = 0

    proc helper(magic: Magic) =
        if turn mod 2 == 0:
            # player turn
            echo turn, "--- player trun ----------------------"
        else:
            echo turn, "--- boss trun ------------------------"

        echo "player:", player
        echo "boss:", boss
        applyEffect(player, turn)
        applyEffect(boss, turn)
        echo "--- effect ---"
        echo "player:", player
        echo "boss:", boss
        if turn mod 2 == 0:
            # player turn
            (player, boss) = castMagic(player, boss, magic, turn)
        else:
            (player, boss) = attack(player, boss)
        # echo "player:", player
        # echo "boss:", boss

    helper(poison)
    turn += 1
    helper(Magic())
    turn += 1
    helper(drain)
    turn += 1
    helper(Magic())
    turn += 1
    helper(recharge)
    turn += 1
    helper(Magic())
    turn += 1
    helper(poison)
    turn += 1
    helper(Magic())
    turn += 1
    helper(shield)
    turn += 1
    helper(Magic())
    turn += 1
    helper(recharge)
    turn += 1
    helper(Magic())
    turn += 1
    helper(poison)
    turn += 1
    helper(Magic())
    turn += 1
    helper(drain)
    turn += 1
    helper(Magic())
    turn += 1
    helper(missile)
    turn += 1
    helper(Magic())
    turn += 1

    echo "mana used:", player.usedMana

proc testSeqCopy() =
    var test = Character()
    test.effect.add(Effect(cost:10))
    echo test
    var test2 = test
    test.effect.add(Effect(cost:20))
    echo test
    echo test2
    # so seq in a Character is indeed deep copy

proc findLowestManaCost() =
    var stack :seq[(Character, Character, int)]

    var player = Character(HP:50, mana: 500)
    var boss = Character(HP:55, damage: 8)
    
    var lowest = -1
    var counter = 0

    stack.add((player,boss,0))

    while len(stack) > 0:
        counter+=1
        # if counter>100:
        #     break

        var (player, boss, turn) = stack.pop()
        # echo turn, " ----------------"
        # echo player
        # echo boss

        if boss.HP <= 0:
            if lowest < 0:
                lowest = player.usedMana
            if lowest > player.usedMana:
                lowest = player.usedMana
            continue

        if player.HP <= 0:
            continue


        applyEffect(player, turn)
        applyEffect(boss, turn)
        
        if boss.HP <= 0:
            if lowest < 0:
                lowest = player.usedMana
            if lowest > player.usedMana:
                lowest = player.usedMana
            continue

        if player.HP <= 0:
            continue

        let magic = @[missile,drain,shield, poison,recharge]

        if turn mod 2 == 0:
        # player turn
            for m in magic:
                if magicActive(m.magicType, player, boss):
                    continue
                if player.mana < m.cost:
                    continue
                let (nextplayer, nextboss) = castMagic(player, boss, m, turn)
                stack.add((nextPlayer, nextBoss, turn + 1))
        else:
            let (nextplayer, nextboss) = attack(player, boss)
            stack.add((nextPlayer, nextBoss, turn + 1))

    echo "lowset mana:", lowest
    echo "counter:", counter
# On the next run through the game, you increase the difficulty to hard.

# At the start of each player turn (before any other effects apply), you lose 1 hit point. If this brings you to or below 0 hit points, you lose.

# With the same starting stats for you and the boss, what is the least amount of mana you can spend and still win the fight?

# this is one of the correct solution 
# 1289
# ['Poison', 'Drain', 'Recharge', 'Poison', 'Shield', 'Recharge', 'Poison', 'Drain', 'Magic_Missile']

proc findLowestManaCostHard() =
    var stack :seq[(Character, Character, int, seq[MagicType])]

    # var player = Character(HP:40, mana: 500)
    # var boss = Character(HP:55, damage: 8)
    var player = Character(HP:50, mana: 500)
    var boss = Character(HP:55, damage: 8)
    
    var lowest = -1
    var counter = 0
    var magicLowest:seq[MagicType]

    stack.add((player,boss,0,@[]))

    while len(stack) > 0:
        counter+=1
        # if counter>10:
        #     break
        var (player, boss, turn, magicUsed) = stack.pop()
        
        if boss.HP <= 0:
            if lowest < 0:
                lowest = player.usedMana
                magicLowest = magicUsed
            if lowest > player.usedMana:
                lowest = player.usedMana
                magicLowest = magicUsed
            continue

        if player.HP <= 0:
            continue

        # 2024-04-29: skip cost that higher than lowest
        # this is why it take so much time 
        if lowest > 0:
            if player.usedMana > lowest:
                continue
        
        if turn mod 2 == 0:
            player.HP -= 1

        if player.HP <= 0:
            continue

        applyEffect(player, turn)
        applyEffect(boss, turn)
        
        if boss.HP <= 0:
            if lowest < 0:
                lowest = player.usedMana
                magicLowest = magicUsed
            if lowest > player.usedMana:
                lowest = player.usedMana
                magicLowest = magicUsed
            continue

        if player.HP <= 0:
            continue

        let magic = @[missile,drain,shield, poison,recharge]

        if turn mod 2 == 0:
        # player turn
            for m in magic:
                if magicActive(m.magicType, player, boss):
                    continue
                if player.mana < m.cost:
                    continue
                let (nextplayer, nextboss) = castMagic(player, boss, m, turn)
                stack.add((nextPlayer, nextBoss, turn + 1, magicUsed & m.magicType))
        else:
            let (nextplayer, nextboss) = attack(player, boss)
            stack.add((nextPlayer, nextBoss, turn + 1, magicUsed))

    echo "lowset mana:", lowest
    echo "migic seq:", magicLowest
    echo "counter:", counter
    

proc main()=
    #testSeqCopy()
    #testPlay()
    #testPlay2()
    #findLowestManaCost() # 953
    findLowestManaCostHard()

main()