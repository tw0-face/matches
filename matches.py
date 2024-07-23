def bit_count(self):
    return bin(self).count("1")
    

numbers = {    
    "0": 0b1111110, 
    "1": 0b0110000, 
    "2": 0b1101110, 
    "3": 0b1111001, 
    "4": 0b0110011, 
    "5": 0b1011011, 
    "6": 0b1011111, 
    "7": 0b1110000, 
    "8": 0b1111111, 
    "9": 0b1111011
    }
signs = {
    "+": 0b0000001,
    "-": 0b0000000
}

expression = input("please enter the expression : ")
number_of_moves = int(input("number of moves : "))
if "+" in expression:
    num_1 = numbers[expression.split('+')[0]]
    num_2 = numbers[expression.split('+')[1][0]]
    sign = signs["+"]
    
elif "-" in expression:
    num_1 = numbers[expression.split('-')[0]]
    num_2 = numbers[expression.split('-')[1][0]]
    sign = signs["-"]
   
    
result = numbers[expression.split('=')[1]]
n_ones_expression =  bit_count(num_1) + bit_count(num_2) + bit_count(result) + bit_count(sign)

def get_key(num):
    for key, value in numbers.items():
        if num == value:
            return str(key)
         
# find hamming weight
def get_possible_values(num):
    possible_values = []
    for nums in numbers.values():
        n_ones = bit_count(num ^ nums)
        if n_ones <= number_of_moves:
            possible_values.append(nums)
        if n_ones == 2*number_of_moves and bit_count(nums) == bit_count(num):
            possible_values.append(nums)
    return possible_values
 


possible_num1 = list(map(get_key, get_possible_values(num_1)))
possible_signs = list(signs.keys())
possible_num2 = list(map(get_key, get_possible_values(num_2)))
possible_result = list(map(get_key, get_possible_values(result)))



list_of_expressions = [n1 + s + n2 + "==" + r for n1 in possible_num1 for s in possible_signs for n2 in possible_num2 for r in possible_result if (bit_count(numbers[n1]) + bit_count(numbers[n2]) + bit_count(signs[s]) + bit_count(numbers[r])) == n_ones_expression and bit_count(numbers[n1] ^ num_1) + bit_count(numbers[n2] ^ num_2) + bit_count(signs[s] ^ sign) + bit_count(numbers[r] ^ result) == 2*number_of_moves]

results = []

for exp in list_of_expressions:
    if eval(exp) == True:
        results.append(exp.replace('=', '', 1))

print(possible_num1)
print(possible_num2)
print(possible_result)
print("######")
print("Possible Answers: ")
print(results)