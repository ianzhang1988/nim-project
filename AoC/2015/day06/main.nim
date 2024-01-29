# Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions include whether to turn on, turn off, or toggle various inclusive ranges given as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights all start turned off.

# To defeat your neighbors this year, all you have to do is set up your lights by doing the instructions Santa sent you in order.

# For example:

# turn on 0,0 through 999,999 would turn on (or leave on) every light.
# toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, and turning on the ones that were off.
# turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
# After following the instructions, how many lights are lit?
import std/strutils

const 
    Toggle = "toggle "
    CmdTurnOn = "turn on "
    CmdTurnOff = "turn off "

type Grid = seq[seq[bool]]

proc initGrid(rows, cols: int): Grid =
  result = newSeq[seq[bool]](rows)
  for i in 0..<rows:
    result[i] = newSeq[bool](cols)

proc getLitNum(self: Grid): int =
    for r in self:
        for c in r:
            if c:
                result = result+1

proc turnOn(self: var Grid, x1,y1,x2,y2: int) =
    for r in y1..y2:
        for c in x1..x2:
            self[r][c] = true
proc turnOff(self: var Grid, x1,y1,x2,y2: int) =
    for r in y1..y2:
        for c in x1..x2:
            self[r][c] = false
proc toggle(self: var Grid, x1,y1,x2,y2: int) =
    for r in y1..y2:
        for c in x1..x2:
            self[r][c] = not self[r][c]
proc exec(self: var Grid, cmd: string, x1,y1,x2,y2: int) =
    case cmd:
    of Toggle:
        self.toggle(x1,y1,x2,y2)
    of CmdTurnOn:
        self.turnOn(x1,y1,x2,y2)
    of CmdTurnOff:
        self.turnOff(x1,y1,x2,y2)

proc parsePos(pos: string): (int, int, int, int) = 
    let parts = pos.split(" ")
    let point1 = parts[0].split(",")
    let point2 = parts[2].split(",")
    return (point1[0].parseInt(), point1[1].parseInt(), point2[0].parseInt(), point2[1].parseInt())


proc parseInstruction(instruction: string): (string, int, int, int, int) =
    
    var start = 0
    var cmd = ""
    if instruction.startsWith(Toggle):
        start = len(Toggle)
        cmd = Toggle
    elif instruction.startsWith(CmdTurnOn):
        start = len(CmdTurnOn)
        cmd = CmdTurnOn
    elif instruction.startsWith(CmdTurnOff):
        start = len(CmdTurnOff)
        cmd = CmdTurnOff
    else:
        echo "bad instruction: ", instruction
        return (cmd, 0,0,0,0)

    let pos = parsePos(instruction[start..<len(instruction)])
    return (cmd, pos[0], pos[1], pos[2], pos[3])

# The phrase turn on actually means that you should increase the brightness of those lights by 1.
# The phrase turn off actually means that you should decrease the brightness of those lights by 1, to a minimum of zero.
# The phrase toggle actually means that you should increase the brightness of those lights by 2.
# What is the total brightness of all lights combined after following Santa's instructions?

# For example:
# turn on 0,0 through 0,0 would increase the total brightness by 1.
# toggle 0,0 through 999,999 would increase the total brightness by 2000000.

type Grid2 = seq[seq[int]]

proc initGrid2(rows, cols: int): Grid2 =
  result = newSeq[seq[int]](rows)
  for i in 0..<rows:
    result[i] = newSeq[int](cols)

proc getBrightness(self: Grid2): int =
    for r in self:
        for c in r:
            result = result+c

proc turnOn2(self: var Grid2, x1,y1,x2,y2: int) =
    for r in y1..y2:
        for c in x1..x2:
            self[r][c] = self[r][c]+1
proc turnOff2(self: var Grid2, x1,y1,x2,y2: int) =
    for r in y1..y2:
        for c in x1..x2:
            self[r][c] = self[r][c]-1
            if self[r][c] < 0:
                self[r][c] = 0
proc toggle2(self: var Grid2, x1,y1,x2,y2: int) =
    for r in y1..y2:
        for c in x1..x2:
            self[r][c] = self[r][c] + 2

proc exec2(self: var Grid2, cmd: string, x1,y1,x2,y2: int) =
    case cmd:
    of Toggle:
        self.toggle2(x1,y1,x2,y2)
    of CmdTurnOn:
        self.turnOn2(x1,y1,x2,y2)
    of CmdTurnOff:
        self.turnOff2(x1,y1,x2,y2)

proc main() = 

    var grid = initGrid(1000,1000)
    var (cmd, x1,y1,x2,y2) = parseInstruction("turn on 0,0 through 999,999")
    grid.exec(cmd, x1,y1,x2,y2)
    echo "turn on 0,0 through 999,999 ", grid.getLitNum()
    (cmd, x1,y1,x2,y2) = parseInstruction("toggle 0,0 through 999,0")
    grid.exec(cmd, x1,y1,x2,y2)
    echo "toggle 0,0 through 999,0 ", grid.getLitNum()
    (cmd, x1,y1,x2,y2) = parseInstruction("turn off 499,499 through 500,500")
    grid.exec(cmd, x1,y1,x2,y2)
    echo "turn off 499,499 through 500,500 ", grid.getLitNum()

    grid = initGrid(1000,1000)
    let data = readFile("input")
    let strList = data.splitLines()
    for i in strList:
        (cmd, x1,y1,x2,y2) = parseInstruction(i)
        grid.exec(cmd, x1,y1,x2,y2)
    echo "lit number: ", grid.getLitNum()

    echo "---------------------"


    var grid2 = initGrid2(1000,1000)
    (cmd, x1,y1,x2,y2) = parseInstruction("turn on 0,0 through 0,0")
    grid2.exec2(cmd, x1,y1,x2,y2)
    echo "turn on 0,0 through 0,0 ", grid2.getBrightness()
    (cmd, x1,y1,x2,y2) = parseInstruction("toggle 0,0 through 999,999")
    grid2.exec2(cmd, x1,y1,x2,y2)
    echo "toggle 0,0 through 999,999 ", grid2.getBrightness()

    grid2 = initGrid2(1000,1000)
    for i in strList:
        (cmd, x1,y1,x2,y2) = parseInstruction(i)
        grid2.exec2(cmd, x1,y1,x2,y2)
    echo "Brightness: ", grid2.getBrightness()


main()