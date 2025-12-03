extends Control


# rules:
# if the first half never changes, there is a max of 1 invalid id


const PRACTICE: String = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124"


var practicing := false


func _ready() -> void:
	var count: int = 0
	
	if practicing:
		var sets: PackedStringArray = PRACTICE.replace("\n", "").split(",")
		for s: String in sets:
			var start: int = s.get_slice("-", 0).to_int()
			var end: int = s.get_slice("-", 1).to_int()
			
			count += invalid_between_pt2(start, end)
	else:
		var file := FileAccess.open("res://day 2/input.txt", FileAccess.READ)
		var line: String = file.get_line()
		var sets: PackedStringArray = line.split(",")
		for s: String in sets:
			var start: int = s.get_slice("-", 0).to_int()
			var end: int = s.get_slice("-", 1).to_int()
			
			count += invalid_between_pt2(start, end)
	
	print(count)


func invalid_between(start: int, end: int) -> int:
	var count: int = 0
	
	var start_str: String = str(start)
	var end_str: String = str(end)
	
	var start_len: int = start_str.length()
	var end_len: int = end_str.length()
	
	var skip: bool = start_len == end_len and start_len % 2 == 1
	
	if not skip:
		#print("----------------------")
		#print(start)
		#print(end) 
		for id: int in range(start, end + 1):
			var str_id: String = str(id)
			if str_id.length() % 2 == 0:
				var first_half: int = str_id.substr(0, (str_id.length() / 2)).to_int()
				var second_half: int = str_id.substr(str_id.length() / 2, -1).to_int()
				#prints(first_half == second_half, first_half - second_half)
				if first_half == second_half:
					count += id
	
	return count


func invalid_between_pt2(start: int, end: int) -> int:
	var count: int = 0
	
	var start_str: String = str(start)
	var end_str: String = str(end)
	
	var start_len: int = start_str.length()
	var end_len: int = end_str.length()
	
	var skip: bool = start_len == end_len and start_len % 2 == 1
	
	if true:#not skip:
		#print("----------------------")
		#print(start)
		#print(end) 
		for id: int in range(start, end + 1):
			#var str_id: String = str(id) #pt1
			if true:#str_id.length() % 2 == 0: #only for pt1
				if pt2_check_brute(id):
					count += id
				#var first_half: int = str_id.substr(0, (str_id.length() / 2)).to_int() #pt1
				#var second_half: int = str_id.substr(str_id.length() / 2, -1).to_int() #pt1
				#prints(first_half == second_half, first_half - second_half)
				#if first_half == second_half: #pt1
					#count += id #pt1
	
	return count


func pt2_check_brute(num: int) -> bool:
	var num_str: String = str(num)
	var first_half: int = num_str.substr(0, (num_str.length() / 2)).to_int()
	var second_half: int = num_str.substr(num_str.length() / 2, -1).to_int()
	
	var first_half_str: String = num_str.substr(0, (num_str.length() / 2))
	var second_half_str: String = num_str.substr(num_str.length() / 2, -1)
	
	for i: int in first_half_str.length():
		var substr: String = first_half_str.substr(0, i + 1)
		if num_str.count(substr) == num_str.length() / substr.length() and num_str.length() % substr.length() == 0:
			#print(num)
			return true
			# phew
	
	return false
