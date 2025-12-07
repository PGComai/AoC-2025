extends Control


const PRACTICE: Array[String] = [
							"123 328  51 64 ",
							" 45 64  387 23 ",
							"  6 98  215 314",
							"*   +   *   +  "]


var practicing := true

var problems: Array[Array] = []

# need to record numbers AND their positions
var problems_2: Array[Dictionary] = []


func _ready() -> void:
	var total: String = "0"
	var first_line_done := false
	var line_ct: int = 0
	
	if practicing:
		for line: String in PRACTICE:
			var problem: int = 0
			var chunks: PackedStringArray = line.split(" ", false)
			for chunk: String in chunks:
				var clean_chunk: String = chunk.strip_edges()
				if not first_line_done:
					problems.append([chunk])
				else:
					problems[problem].append(chunk)
				problem += 1
			first_line_done = true
			
			var current_i: int = 0
			var on_num := false
			var current_num: String = ""
			var keep_i: int = 0
			for i: int in line.length():
				keep_i = i
				var char: String = line[i]
				if char == " ":
					if on_num:
						if problems_2.size() <= current_i:
							problems_2.append({str(line_ct) + "." + str(i - 1): current_num})
						else:
							problems_2[current_i][str(line_ct) + "." + str(i - 1)] = current_num
						current_num = ""
						on_num = false
						current_i += 1
				else:
					if not on_num:
						on_num = true
					current_num += char
			if current_num != "":
				
				if problems_2.size() <= current_i:
					problems_2.append({str(line_ct) + "." + str(keep_i): current_num})
				else:
					problems_2[current_i][str(line_ct) + "." + str(keep_i)] = current_num
			line_ct += 1
	else:
		var file := FileAccess.open("res://day 6/input.txt", FileAccess.READ)
		while file.get_position() < file.get_length():
			var line: String = file.get_line()
			var problem: int = 0
			var chunks: PackedStringArray = line.split(" ", false)
			for chunk: String in chunks:
				var clean_chunk: String = chunk.strip_edges()
				if not first_line_done:
					problems.append([chunk])
				else:
					problems[problem].append(chunk)
				problem += 1
			first_line_done = true
	
	
	for problem: Array[String] in problems:
		var operator: String = problem[-1]
		var result: int = problem[0].to_int()
		#print(problem)
		for operand: String in problem.slice(1, -1):
			if operator == "*":
				result *= operand.to_int()
			elif operator == "+":
				result += operand.to_int()
		total = long_add(total, str(result))
	
	print(total)
	print("-------------")
	
	print(problems_2)
	print("-------------")
	
	var problems_2_again: Array[Array] = []
	
	var problem_num: int = 0
	
	for p2: Dictionary in problems_2:
		print(p2)
		var col_min: int = -1
		var col_max: int = -1
		for pos: String in p2:
			var value: String = p2[pos]
			if value.is_valid_int():
				var line_num: int = pos.get_slice(".", 0).to_int()
				var col_end: int = pos.get_slice(".", 1).to_int()
				var value_len: int = value.length()
				var col_start: int = col_end - value_len + 1
				
				if col_end > col_max:
					col_max = col_end
				if col_min == -1:
					col_min = col_start
				elif col_start < col_min:
					col_min = col_start
		
		prints(col_min, "to", col_max)
		
		if problems_2_again.size() <= problem_num:
			problems_2_again.append([])
		var dummy_num: String = "X"
		for i in col_max - col_min:
			dummy_num += "X"
		for i in p2.size() - 1:
			problems_2_again[problem_num].append(dummy_num)
		problems_2_again[problem_num].append(p2[p2.keys()[-1]])
		
		
		var problem_again_again: Array[String] = []
		for col: int in range(col_min, col_max + 1):
			for pos: String in p2:
				var value: String = p2[pos]
				if value.is_valid_int():
					var line_num: int = pos.get_slice(".", 0).to_int()
					var col_end: int = pos.get_slice(".", 1).to_int()
					
					var digits: Dictionary = {}
					var ct: int = 0
					for d: String in value.split(""):
						digits[ct + col_min] = d
						ct += 1
					
					if digits.has(col):
						var i: int = col - col_min
						if problem_again_again.size() <= i:
							problem_again_again.append(digits[col])
						else:
							problem_again_again[i] += digits[col]
						#print(digits[col])
						problems_2_again[problem_num]
			print("-------")
		problem_num += 1
		print(problem_again_again)
		
	print("-------------")
	
	#print(problems_2_again)
	
	# pt 2 attempt 1
	#var problems_2: Array[Array] = []
	#var count: int = 0
	#for problem: Array[String] in problems:
		#var max_len: int = 0
		#var longest_num: String = "0"
		#for operand: String in problem.slice(0, -1):
			#if longest_num == "0":
				#longest_num = operand
			#else:
				#if operand.length() > longest_num.length():
					#longest_num = operand
			#max_len = longest_num.length()
		#for i: int in max_len:
			#var new_num: String = ""
			#for operand: String in problem.slice(0, -1):
				##print(operand)
				#if operand.length() < max_len:
					#var padding: String = ""
					#for p in max_len - operand.length():
						#padding += "X"
					#operand = padding + operand
				#print(operand)
				##print(operand[-(i + 1)])
				#var new_digit: String = operand[-(i + 1)]
				#if new_digit != "X":
					#new_num += operand[-(i + 1)]
			#while new_num.begins_with("0"):
				#new_num.trim_prefix("0")
			#print("-------------")
			#print(new_num)
			#print("-------------")
			#if problems_2.size() <= count:
				#problems_2.append([new_num])
			#else:
				#problems_2[count].append(new_num)
		#count += 1
	#print(problems_2)


func long_add(top: String, bottom: String) -> String:
	var result: String = ""
	
	var max_len: int = maxi(top.length(), bottom.length())
	
	var padding: String = ""
	if top.length() < max_len:
		for i in max_len - top.length():
			padding += "0"
		top = padding + top
	elif bottom.length() < max_len:
		for i in max_len - bottom.length():
			padding += "0"
		bottom = padding + bottom
	
	top = "0" + top
	bottom = "0" + bottom
	
	#print("-----------------------")
	#prints(top, "+", bottom)
	
	
	for i in max_len * 2:
		result += "0"
	
	var carry: int = 0
	
	for i: int in bottom.length():
		i += 1
		
		var top_digit: int = top[-i].to_int()
		var bottom_digit: int = bottom[-i].to_int()
		
		#prints(top_digit, "+", bottom_digit)
		
		var sum: int = top_digit + bottom_digit + carry
		if sum > 9:
			carry = 1
			sum -= 10
		else:
			carry = 0
		
		result[-i] = str(sum)
	
	while result.begins_with("0"):
		result = result.substr(1)
	
	#print(result)
	
	return result
