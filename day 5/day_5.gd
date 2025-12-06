extends Control


const PRACTICE: Array[String] = [
							"3-5",
							"10-14",
							"16-20",
							"12-18",
							"",
							"1",
							"5",
							"8",
							"11",
							"17",
							"32",]


var practicing := false

var fresh_ranges: Array[Array] = []
var fresh_ranges_unique: Array[Array] = []
var products: Array[String] = []
var getting_ranges := true


func _ready() -> void:
	if practicing:
		for line: String in PRACTICE:
			if line == "":
				getting_ranges = false
			elif getting_ranges:
				var range_min: String = line.get_slice("-", 0)
				var range_max: String = line.get_slice("-", 1)
				fresh_ranges.append([range_min, range_max])
			else:
				products.append(line)
	else:
		var file := FileAccess.open("res://day 5/input.txt", FileAccess.READ)
		while file.get_position() < file.get_length():
			var line: String = file.get_line()
			if line == "":
				getting_ranges = false
			elif getting_ranges:
				var range_min: String = line.get_slice("-", 0)
				var range_max: String = line.get_slice("-", 1)
				fresh_ranges.append([range_min, range_max])
			else:
				products.append(line)
	
	var num_fresh: int = 0
	
	for product: String in products:
		var fresh: bool = is_fresh(product)
		if fresh:
			num_fresh += 1
	
	print(num_fresh)
	
	var og_num_ranges: int = fresh_ranges.size()
	var ranges_overlap := true
	fresh_ranges_unique = fresh_ranges.duplicate(true)
	while ranges_overlap:
		var overlapping_ranges: Array[int] = find_range_overlap(fresh_ranges_unique)
		if overlapping_ranges.size() == 0:
			ranges_overlap = false
		else:
			var range_0: Array = fresh_ranges_unique[overlapping_ranges[0]]
			var range_1: Array = fresh_ranges_unique[overlapping_ranges[1]]
			prints(range_0, "overlaps with", range_1)
			var min_0: String = range_0[0]
			var max_0: String = range_0[1]
			var min_1: String = range_1[0]
			var max_1: String = range_1[1]
			
			var min_0_in_1: bool = less_than(min_1, min_0, true) and greater_than(max_1, min_0, true)
			var max_0_in_1: bool = less_than(min_1, max_0, true) and greater_than(max_1, max_0, true)
			var min_1_in_0: bool = less_than(min_0, min_1, true) and greater_than(max_0, min_1, true)
			var max_1_in_0: bool = less_than(min_0, max_1, true) and greater_than(max_0, max_1, true)
			
			if min_0_in_1 or max_0_in_1 or min_1_in_0 or max_1_in_0:
				var new_min: String
				var new_max: String
				
				if less_than(min_0, min_1, true):
					new_min = min_0
				else:
					new_min = min_1
				
				if greater_than(max_0, max_1, true):
					new_max = max_0
				else:
					new_max = max_1
				
				fresh_ranges_unique.erase(range_0)
				fresh_ranges_unique.erase(range_1)
				fresh_ranges_unique.append([new_min, new_max])
				prints("new range is", [new_min, new_max])
	
	prints("reduced range count from", og_num_ranges, "to",  fresh_ranges_unique.size())
	#print(fresh_ranges_unique)
	
	var diffs: Array[String] = []
	for fresh_range: Array in fresh_ranges_unique:
		var result: String = long_subtract(fresh_range[1], fresh_range[0])
		#print(result)
		diffs.append(result)
		diffs.append("1")
	
	var sum: String = "0"
	for d: String in diffs:
		sum = long_add(sum, d)
	
	print(sum)
	
	#print(long_subtract("4639", "1248"))
	#print(4639 - 1248)
	#print(long_subtract("440454991965740", "437720846119634"))


func find_range_overlap(ranges: Array[Array]) -> Array[int]:
	
	for i0: int in ranges.size():
		for i1: int in ranges.size():
			if i0 == i1:
				pass
			else:
				var r0: Array = ranges[i0]
				var r1: Array = ranges[i1]
				
				var min_0: String = r0[0]
				var max_0: String = r0[1]
				var min_1: String = r1[0]
				var max_1: String = r1[1]
				
				var min_0_in_1: bool = less_than(min_1, min_0, true) and greater_than(max_1, min_0, true)
				var max_0_in_1: bool = less_than(min_1, max_0, true) and greater_than(max_1, max_0, true)
				var min_1_in_0: bool = less_than(min_0, min_1, true) and greater_than(max_0, min_1, true)
				var max_1_in_0: bool = less_than(min_0, max_1, true) and greater_than(max_0, max_1, true)
		
				if min_0_in_1 or max_0_in_1 or min_1_in_0 or max_1_in_0:
					return [i0, i1]
	
	return []


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


func long_subtract(minuend: String, subtrahend: String) -> String:
	#print("-----------------------")
	#print(minuend)
	#print(subtrahend)
	#print("-----------------------")
	#prints(minuend, "-", subtrahend)
	if minuend == subtrahend:
		return "0"
	var result: String = ""
	
	for i in minuend.length():
		result += "0"
	
	for i: int in subtrahend.length():
		#i = subtrahend.length() - i
		i += 1
		#print(i)
		var minu_digit: int = minuend[-i].to_int()
		var subt_digit: int
		if i < subtrahend.length() + 1:
			subt_digit = subtrahend[-i].to_int()
		else:
			subt_digit = 0
		
		#prints(minu_digit, "-", subt_digit)
		
		if minu_digit < subt_digit:
			var iter: int = 1
			var next_minu_digit: int = minuend[-(i + iter)].to_int()
			while next_minu_digit == 0:
				iter += 1
				next_minu_digit = minuend[-(i + iter)].to_int()
				minuend[-(i + (iter - 1))] = str(9)
			minuend[-(i + iter)] = str(next_minu_digit - 1)
			minu_digit += 10
		
		result[-i] = str(minu_digit - subt_digit)
	
	while result.begins_with("0"):
		result = result.substr(1)
	
	return result


func is_fresh(product: String) -> bool:
	var between: bool = false
	for fresh_range: Array in fresh_ranges:
		var min_fresh: String = fresh_range[0]
		var max_fresh: String = fresh_range[1]
		between = less_than(product, str(max_fresh), true)\
		and greater_than(product, str(min_fresh), true)
		if between:
			return between
	return between


func less_than(input: String, compare: String, or_equal_to: bool = false) -> bool:
	if input == compare:
		return or_equal_to
	
	var input_len: int = input.length()
	var compare_len: int = compare.length()
	
	if input_len < compare_len:
		return true
	elif input_len > compare_len:
		return false
	else:
		for i in input_len:
			var input_digit: int = input[i].to_int()
			var compare_digit: int = compare[i].to_int()
			if input_digit < compare_digit:
				return true
			elif input_digit > compare_digit:
				return false
	
	return false


func greater_than(input: String, compare: String, or_equal_to: bool = false) -> bool:
	if input == compare:
		return or_equal_to
	
	var input_len: int = input.length()
	var compare_len: int = compare.length()
	
	if input_len > compare_len:
		return true
	elif input_len < compare_len:
		return false
	else:
		for i in input_len:
			var input_digit: int = input[i].to_int()
			var compare_digit: int = compare[i].to_int()
			if input_digit > compare_digit:
				return true
			elif input_digit < compare_digit:
				return false
	
	return false
