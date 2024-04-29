# https://github.com/mattbillenstein/aoc/blob/main/2015/22/p.py

#!/usr/bin/env pypy3

import copy
import sys
from pprint import pprint

from graph import dfs

DEBUG = sys.argv.count('-v')

def debug(*args):
    if DEBUG:
        print(*args)

def parse_input():
    # lines = [_.strip('\r\n') for _ in sys.stdin]
    # boss = {}
    # for line in lines:
    #     a, b = line.split(': ')
    #     if a == 'Hit Points':
    #         a = 'hp'
    #     a = a.lower()
    #     boss[a] = int(b)

    spells = []
    for line in open('spells.txt'):
        line = line.strip()
        if not line:
            continue

        if line.startswith('-'):
            continue

        name, cost, dmg, armor, hp, turns, mana = [int(_) if _.isdigit() else _ for _ in line.split()]
        spells.append({
            'name': name,
            'cost': cost,
            'damage': dmg,
            'armor': armor,
            'hp': hp,
            'turns': turns,
            'mana': mana,
        })

    player = {
        'hp': 50,
        'mana': 500,
        'armor': 0,
        'mana_used': 0,
        'effects': {},
    }
    boss = {"hp": 55, "damage":8}
    # player = {
    #     'hp': 40, 
    #     'mana': 500,
    #     'armor': 0,
    #     'mana_used': 0,
    #     'effects': {},
    # }
    # boss = {"hp": 55, "damage":8}

    return player, boss, spells

class BadState(Exception):
    pass

counter = 0

class State:
    def __init__(self, player, boss, spells, part, casted, spell=None):
        self.player = copy.deepcopy(player)
        self.boss = copy.deepcopy(boss)
        self.spells = spells

        self.part = part
        global counter
        counter += 1

        self.casted = []
        self.casted.extend(casted)

        if spell:
            if self.part == 2:
                self.player['hp'] -= 1
                if self.player['hp'] <= 0:
                    raise BadState('Player Died')

            # fight yielding a valid new state or raising BadState
            self.do_effects()
            if self.boss['hp'] <= 0:
                return

            # player casts
            if self.player['mana'] < spell['cost']:
                raise BadState('No mana')

            # cast
            self.player['mana'] -= spell['cost']
            self.player['mana_used'] += spell['cost']
            if spell['turns']:
                if spell['name'] in self.player['effects']:
                    raise BadState('Effect in use')
                self.player['effects'][spell['name']] = spell = copy.deepcopy(spell)
                self.casted.append(spell['name'])
            else:
                self.casted.append(spell['name'])
                self.player['hp'] += spell['hp']
                self.boss['hp'] -= spell['damage']
                if self.boss['hp'] <= 0:
                    return

            # boss turn
            self.do_effects()
            if self.boss['hp'] <= 0:
                return

            self.player['hp'] -= max(1, self.boss['damage'] - self.player['armor'])
            if self.player['hp'] <= 0:
                raise BadState('Player Died')

    def do_effects(self):
        self.player['armor'] = 0

        remove = []
        for k, e in self.player['effects'].items():
            self.boss['hp'] -= e['damage']

            self.player['armor'] += e['armor']
            self.player['mana'] += e['mana']
            self.player['hp'] += e['hp']

            e['turns'] -= 1
            if e['turns'] <= 0:
                remove.append(k)

        # remove expired effects
        for k in remove:
            del self.player['effects'][k]

    @property
    def done(self):
        # if we're done
        return self.player['hp'] > 0 and self.boss['hp'] <= 0

    @property
    def key(self):
        # the key into the visited dict if applicable
        return ''

    @property
    def cost(self):
        # cost, lower is better
        return self.player['mana_used']

    def next(self):
        # next states
        for spell in self.spells:
            try:
                yield self.__class__(self.player, self.boss, self.spells, self.part,self.casted, spell)
            except BadState:
                pass

    def __repr__(self):
        return f'State({self.player}, {self.boss}, {self.cost})'

def part1(player, boss, spells):
    if DEBUG:
        print(player)
        print(boss)
        pprint(spells)

    state = State(player, boss, spells, 1,[])
    best = dfs(state)
    print(best.cost)

def part2(player, boss, spells):
    if DEBUG:
        print(player)
        print(boss)
        pprint(spells)

    state = State(player, boss, spells,2,[])
    best = dfs(state)
    print(best.cost)
    print(best.casted)
    print(counter)

def main():
    data = parse_input()
    if '1' in sys.argv:
        part1(*data)
    if '2' in sys.argv:
        part2(*data)

if __name__ == '__main__':
    main()