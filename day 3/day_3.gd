extends Control


const PRACTICE: Array[String] = [
								"987654321111111",
								"811111111111119",
								"234234234234278",
								"818181911112111"
								]


var practicing := false


func _ready() -> void:
	var total: int = 0
	if practicing:
		for line: String in PRACTICE:
			#total += do_it(line)
			#print(line)
			total += largest_num_for_len(line, 12).to_int()
	else:
		var file := FileAccess.open("res://day 3/input.txt", FileAccess.READ)
		while file.get_position() < file.get_length():
			var line: String = file.get_line()
			#total += do_it(line)
			total += largest_num_for_len(line, 12).to_int()
	
	print(total)


func do_it(num: String) -> int:
	var joltage: int = 0
	var digits_int: Array[int] = []
	
	var digits: PackedStringArray = num.split("")
	var starting_digits: PackedStringArray = digits.duplicate()
	starting_digits.remove_at(starting_digits.size() - 1)
	
	for d: String in digits:
		digits_int.append(d.to_int())
	
	var starting_digits_int: Array[int] = digits_int.duplicate()
	starting_digits_int.remove_at(starting_digits_int.size() - 1)
	
	var digit_1: int = starting_digits_int.max()
	var digit_1_indices: Array[int] = []
	
	for i: int in starting_digits_int.size():
		var di: int = starting_digits_int[i]
		if di == digit_1:
			digit_1_indices.append(i)
	
	for d1i: int in digit_1_indices:
		var the_rest_of_them: Array[int] = digits_int.slice(d1i + 1)
		var digit_2_candidate: int = the_rest_of_them.max()
		var j: int = (digit_1 * 10) + digit_2_candidate
		
		joltage = maxi(joltage, j)
	
	return joltage


func do_it_pt2(num: String) -> int: # needs recursion
	var joltage: int = 0
	var digits_int: Array[int] = []
	
	var digits: PackedStringArray = num.split("")
	var starting_digits: PackedStringArray = digits.slice(0, -11)
	
	for d: String in digits:
		digits_int.append(d.to_int())
	
	var starting_digits_int: Array[int] = digits_int.slice(0, -11)
	
	var digit_1: int = starting_digits_int.max()
	var digit_1_indices: Array[int] = []
	
	for i: int in starting_digits_int.size():
		var di: int = starting_digits_int[i]
		if di == digit_1:
			digit_1_indices.append(i)
	
	for d1i: int in digit_1_indices:
		var the_rest_of_them: Array[int] = digits_int.slice(d1i + 1)
		var digit_2_candidate: int = the_rest_of_them.max()
		var j: int = (digit_1 * 10) + digit_2_candidate
		
		joltage = maxi(joltage, j)
	
	return joltage


func largest_num_for_len(num: String, len: int, result: String = "") -> String:
	var digits_int: Array[int] = []
	
	var digits: PackedStringArray = num.split("")
	if len == 1:
		for d: String in digits:
			digits_int.append(d.to_int())
		return result + str(digits_int.max())
	else:
		var starting_digits: PackedStringArray = digits.slice(0, -(len - 1))
		
		for d: String in digits:
			digits_int.append(d.to_int())
		
		var starting_digits_int: Array[int] = digits_int.slice(0, -(len - 1))
		
		var digit_1: int = starting_digits_int.max()
		#print(digit_1)
		var digit_1_indices: Array[int] = []
		for i: int in starting_digits_int.size():
			var di: int = starting_digits_int[i]
			if di == digit_1:
				digit_1_indices.append(i)
		
		var first_digit_1_index: int = digit_1_indices.min()
		#prints(digit_1, num, len, first_digit_1_index)
		result += str(digit_1)
		
		var next_num: String = num.substr(first_digit_1_index + 1)
		
		return largest_num_for_len(next_num, len - 1, result)
