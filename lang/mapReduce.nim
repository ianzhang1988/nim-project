import sequtils

let numbers = [1, 2, 3, 4, 5]
let squares = map(numbers, proc (x: int): int = x*x)

echo squares  # 输出 [1, 4, 9, 16, 25]

var sum: int
apply(numbers, proc (x: int) = sum += x)
echo sum