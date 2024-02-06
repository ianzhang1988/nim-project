# The included instructions booklet describes how to connect the parts together: x AND y -> z means to connect wires x and y to an AND gate, and then connect its output to wire z.

# For example:

# 123 -> x means that the signal 123 is provided to wire x.
# x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
# p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
# NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.
# Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to emulate the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide operators for these gates.

# For example, here is a simple circuit:

# 123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i
# After it is run, these are the signals on the wires:

# d: 72
# e: 507
# f: 492
# g: 114
# h: 65412
# i: 65079
# x: 123
# y: 456
# In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?

# shitty example lead to shitty code, not my 


import std/tables
import std/bitops
import std/strutils
import regex
import std/strformat

type
    wire = object
        signal: uint16
        name: string
    gate = object
        wire1: wire
        wire2: wire
        output: wire
        param : int
        gateType : string
    CircuitType = enum
        WireType, GateType, NoValid
    
    Circuit = object
        case kind: CircuitType
        of WireType:
            wire: wire
        of GateType:
            gate: gate
        of NoValid:
            discard

    SignalState = TableRef[string, uint16]

proc setWire(self: SignalState, w: wire) =
    self[w.name] = w.signal

proc getWire(self: SignalState, name: string): (wire, bool) =
    if not self.contains(name):
        return (wire(), false)
    return (wire( name: name, signal: self[name]), true)

proc andGate(self: var gate) :wire =
    self.output.signal =  bitand(self.wire1.signal, self.wire2.signal)
    return self.output
proc orGate(self: var gate) :wire =
    self.output.signal =  bitor(self.wire1.signal, self.wire2.signal)
    return self.output
proc lshiftGate(self: var gate) : wire=
    self.output.signal =  self.wire1.signal shl self.param
    return self.output
proc rshiftGate(self: var gate) : wire=
    self.output.signal =  self.wire1.signal shr self.param
    return self.output
proc notGate(self: var gate) : wire=
    self.output.signal =  bitnot(self.wire1.signal)
    return self.output

proc updateGateInput(self: var gate, wireSignal: SignalState): bool =
    var ok: bool
    result = true
    # wire.name is 1
    if self.wire1.name == "1":
        # here is a patch for `1 AND x -> y`, so gate can set a signal directly, WTF, uncool dude.
        self.wire1 = wire(name:"", signal: 1)
    elif self.wire1.name != "":
        (self.wire1, ok) = wireSignal.getWire(self.wire1.name)
        result = result and ok

    if self.wire2.name != "":
        (self.wire2, ok) = wireSignal.getWire(self.wire2.name)
        result = result and ok

proc runGate(self: var gate): wire =

    case self.gateType:
    of "AND":
        return self.andGate()
    of "OR":
        return self.orGate()
    of "LSHIFT":
        return self.lshiftGate()
    of "RSHIFT":
        return self.rshiftGate()
    of "NOT":
        return self.notGate()

proc parseWire(text: string): (wire, bool) =
    var w: wire
    var m: RegexMatch2
    if text.match(re2"(\d+) -> (\w+)", m):
        # echo "signal: ", text[m.group(0)]
        # echo "wire name: ", text[m.group(1)]
        w = wire(
            signal: uint16(text[m.group(0)].parseUInt()),
            name: text[m.group(1)]
        )
        return (w, true)
    else:
        return (wire(), false)

proc parseGate(text: string): (gate, bool) =
    var g: gate
    var m: RegexMatch2
    if text.match(re2"(\w+) (\w+) ([a-zA-Z]+) -> (\w+)", m):
        g = gate(
            wire1: wire(name: text[m.group(0)]),
            wire2: wire(name: text[m.group(2)]),
            output: wire(name: text[m.group(3)]),
            gateType: text[m.group(1)]
        )
        return (g, true)
    elif text.match(re2"(\w+) (\w+) (\d+) -> (\w+)", m):
        g = gate(
            wire1: wire(name: text[m.group(0)]),
            output: wire(name: text[m.group(3)]),
            param: text[m.group(2)].parseInt(),
            gateType: text[m.group(1)]
        )
        return (g, true)
    elif text.match(re2"(\w+) (\w+) -> (\w+)", m):
        g = gate(
            wire1: wire(name: text[m.group(1)]),
            output: wire(name: text[m.group(2)]),
            gateType: text[m.group(0)]
        )
        return (g, true)
    else:
        return (gate(), false)


proc ParseOneCircuit(line: string): Circuit =
    block:
        let (w, ok) = parseWire(line)
        if ok:
            return Circuit(kind: WireType, wire: w)
    block:
        let (g, ok) = parseGate(line)
        if ok:
            return Circuit(kind: GateType, gate: g)

    return Circuit(kind: NoValid)
        
proc RunCircuit(lines: seq[string], wireSignal: var SignalState) =
    var remainGate: seq[gate] = @[] 
    for text in lines:
        # echo "process: ", text
        var c = ParseOneCircuit(text)
        case c.kind:
        of WireType:
            # echo c.wire
            wireSignal.setWire(c.wire)
        of GateType:
            # echo c.gate
            remainGate.add(c.gate)
        else:
            discard

    echo wireSignal
    for g in remainGate:
        echo g

    echo "---------------------------------------"

    while len(remainGate) > 0:
        var idx : int
        for i, g in remainGate:
            idx = i
            var gg = g
            if gg.updateGateInput(wireSignal):
                let outWire = gg.runGate()
                echo "old",g
                echo gg
                wireSignal.setWire(outWire)
                break

        remainGate.del(idx)

proc main() =
    var wireSignal: SignalState = newTable[string, uint16]()

    let lines = @["123 -> x", "456 -> y", "x AND y -> d", "x OR y -> e", "x LSHIFT 2 -> f", "y RSHIFT 2 -> g", "NOT x -> h", "NOT y -> i"]
    let wireResult = {"d": 72, "e": 507, "f": 492, "g": 114, "h": 65412, "i": 65079, "x": 123, "y": 456}.toTable

    RunCircuit(lines, wireSignal)

    for (n,v) in wireSignal.pairs:
        echo fmt "{n} -> {v} = {wireResult[n]}"

    echo "-------------------------------------------------------"

    let data = readFile("input")
    let strList = data.splitLines()

    wireSignal = newTable[string, uint16]()
    RunCircuit(strList, wireSignal)

    for (n,v) in wireSignal.pairs:
        echo fmt "{n} -> {v}"

    let aName = "lx" # lx -> a, they did not say this is possible :\
    echo fmt"a -> {wireSignal[aName]}"

    # part 2
    let newData = data.replace("1674 -> b", "46065 -> b")
    let newStrList = newData.splitLines()


    wireSignal = newTable[string, uint16]()
    RunCircuit(newStrList, wireSignal)

    # for (n,v) in wireSignal.pairs:
    #     echo fmt "{n} -> {v}"

    echo fmt"part2 a -> {wireSignal[aName]}"

    # part1 -> 46065
    # part2 -> 14134

main()