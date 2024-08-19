import strutils, strformat

# The manual explains that the computer supports two registers and six instructions (truly, it goes on to remind the reader, a state-of-the-art technology). The registers are named a and b, can hold any non-negative integer, and begin with a value of 0. The instructions are as follows:

# hlf r sets register r to half its current value, then continues with the next instruction.
# tpl r sets register r to triple its current value, then continues with the next instruction.
# inc r increments register r, adding 1 to it, then continues with the next instruction.
# jmp offset is a jump; it continues with the instruction offset away relative to itself.
# jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
# jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
# All three jump instructions work with an offset relative to that instruction. The offset is always written with a prefix + or - to indicate the direction of the jump (forward or backward, respectively). For example, jmp +1 would simply continue with the next instruction, while jmp +0 would continuously jump back to itself forever.

# The program exits when it tries to run an instruction beyond the ones defined.

# For example, this program sets a to 2, because the jio instruction causes it to skip the tpl instruction:

# inc a
# jio a, +2
# tpl a
# inc a
# What is the value in register b when the program in your puzzle input is finished executing?

type Instruction = object
    name: string
    register: string
    param1: int

type VM = object
    instrctionList: seq[Instruction]
    regA: uint
    regB: uint
    pos: int

proc `$` (self: var VM):string =
    return fmt"a:{self.regA} b:{self.regB} pos:{self.pos}"

proc NewVm(input: seq[Instruction]): VM =
    return VM(instrctionList: input, regA:0, regB:0, pos:0)

proc exec(self: var VM): bool = 
    if self.pos >= self.instrctionList.len:
        return false

    let ins = self.instrctionList[self.pos]

    # echo ("----------")
    # echo (ins)
    # echo (self)

    var pr: ptr uint

    case ins.register:
    of "a":
        pr = addr self.regA
    of "b":
        pr = addr self.regB
    

    case ins.name:
    of "hlf":
        pr[] = pr[] shr 1
        self.pos += 1
    of "tpl":
        pr[] = pr[] * 3
        self.pos += 1
    of "inc":
        pr[] = pr[] + 1
        self.pos += 1
    of "jmp":
        self.pos += ins.param1
    of "jie":
        if pr[] mod 2 == 0:
            self.pos += ins.param1
        else:
            self.pos += 1
    of "jio":
        if pr[] == 1:
            self.pos += ins.param1
        else:
            self.pos += 1

    # echo("exec")
    # echo (self)

    return true

proc run(self: var VM) = 
    while true:
        if not self.exec():
            break

proc parseLine(line: string): Instruction =
    let parts = line.split(" ")
    let name = parts[0]

    case name:
    of "jio", "jie":
        result = Instruction(name: name, register:parts[1][0..^2], param1: parts[2].parseInt())
    of "jmp":
        result = Instruction(name: name, param1:parts[1].parseInt())
    else:
        result = Instruction(name: name, register:parts[1])

proc parseInput(data: string):seq[Instruction] =
    for l in data.splitLines():
        let p = parseLine(l)
        result.add(p)

# inc a
# jio a, +2
# tpl a
# inc a
proc test() = 
    let insList = @[
        Instruction(name: "inc", register: "a"),
        Instruction(name: "jio", register: "a", param1: +2),
        Instruction(name: "tpl", register: "a"),
        Instruction(name: "inc", register: "a"),
    ]
    var vm = NewVm(insList)
    vm.run()
    echo vm.regA

proc main() =
    let input = readFile("input")
    let instructions = parseInput(input)
    # for i in instructions:
    #     echo(i)
    var vm = NewVm(instructions)
    vm.run()
    echo vm.regB

    echo("---- part 2 ----")

    vm = NewVm(instructions)
    vm.regA = 1
    vm.run()
    echo vm.regB
    
# test()
main()