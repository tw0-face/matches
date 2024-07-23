import tables, strutils, bitops, sequtils

var data_table = {"0": 0b1111110, "1": 0b0110000, "2": 0b1101110, "3": 0b1111001,"4": 0b0110011,"5": 0b1011011,"6": 0b1011111,"7": 0b1110000,"8": 0b1111111,"9": 0b1111011}.toTable 
  
var signs = {"+": 0b0000001,"-": 0b0000000}.toTable 


write(stdout, "please enter the expression : ")
let expression = readline(stdin)
write(stdout, "number of moves : ")
let number_of_moves = parseInt(readLine(stdin))

var num_1, num_2, sign, result: int 

if "+" in expression:
    num_1 = data_table[expression.split('+')[0]]
    num_2 = data_table[$(expression.split('+')[1][0])]
    sign = signs["+"]

elif "-" in expression:
    num_1 = data_table[expression.split('-')[0]]
    num_2 = data_table[$(expression.split('-')[1][0])]
    sign = signs["-"]


result = data_table[expression.split('=')[1]]
let n_ones_expression =  countSetBits(num_1) + countSetBits(num_2) + countSetBits(result) + countSetBits(sign)

proc get_key(num:int): string =
  for k, v in data_table.pairs:
    if num == v:
      return k

proc get_possible_values(num:int) : seq[int] =
    var possible_values:seq[int]
    possible_values = @[]
    var n_ones:int
    for k, nums in data_table.pairs:
        n_ones = countSetBits(num xor nums)
        if n_ones <= number_of_moves:
            possible_values.add(nums)
        if n_ones == 2*number_of_moves and countSetBits(nums) == countSetBits(num):
            possible_values.add(nums)
    return possible_values

let possible_num1 :seq[string] = map(get_possible_values(num_1), get_key)
var possible_signs :seq[string] 
for k in signs.keys():
  possible_signs.add(k)
let possible_num2 :seq[string] = map(get_possible_values(num_2), get_key)
let possible_result :seq[string] = map(get_possible_values(result), get_key)

var list_of_expressions :seq[string] = @[]
for n1 in possible_num1:
    for s in possible_signs:
        for n2 in possible_num2:
            for r in possible_result:
                if (countSetBits(data_table[n1]) + countSetBits(data_table[n2]) + countSetBits(signs[s]) + countSetBits(data_table[r])) == n_ones_expression and countSetBits(data_table[n1] xor num_1) + countSetBits(data_table[n2] xor num_2) + countSetBits(signs[s] xor sign) + countSetBits(data_table[r] xor result) == 2*number_of_moves:
                    list_of_expressions.add(n1 & s & n2& "=" & r)

proc eval(expression:string):bool =
  var num_1, num_2, lhs, rhs : int
  if "+" in expression:
      num_1 = parseInt(expression.split('+')[0])
      num_2  = parseInt($(expression.split('+')[1][0]))
      lhs  = num_1 + num_2
  elif "-" in expression:
      num_1  = parseInt(expression.split('-')[0])
      num_2  = parseInt($(expression.split('-')[1][0]))
      lhs  = num_1 - num_2
  rhs = parseInt(expression.split('=')[1])
  
  if lhs==rhs:
    return true
  else:
    return false


var results :seq[string] = @[]

for exp in list_of_expressions:
    if eval(exp) == true:
        results.add($exp)

echo possible_num1
echo possible_num2
echo possible_result
echo "######"
echo "Possible Answers: "
echo results