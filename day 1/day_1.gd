extends Control


const PRACTICE = ["R1000"]#, "L23", "L5", "R67", "R201"]


var pos: int = 50:
	set(value):
		pos = wrapi(value, 0, 100)
var testing := false
var brute := false
var pos_brute: int = 50


func _ready() -> void:
	var file := FileAccess.open("res://day 1/input.txt", FileAccess.READ)
	var count: int = 0
	var real_count: int = 0
	var brute_count: int = 0
	
	if testing:
		for p: String in PRACTICE:
			var line: String = p
			var dir: String = line[0]
			var steps: int = line.erase(0).to_int()
			if dir == "L":
				if steps >= pos:
					if pos:
						real_count += 1
					var steps_left_after_first_zero: int = steps - pos
					real_count += steps_left_after_first_zero / 100
				pos -= steps
			else:
				if steps >= (100 - pos):
					if pos:
						real_count += 1
					var steps_left_after_first_zero: int = steps - (100 - pos)
					real_count += steps_left_after_first_zero / 100
				pos += steps
			
			if pos == 0:
				count += 1
	else:
		while file.get_position() < file.get_length():
			var line: String = file.get_line()
			var dir: String = line[0]
			var steps: int = line.erase(0).to_int()
			var test_real: int
			var test_brute: int
			var old_brute: int = brute_count
			var old_real: int = real_count
			var old_pos_brute: int = pos_brute
			var old_pos_real: int = pos
			if dir == "L":
				for step in steps:
					pos_brute -= 1
					if pos_brute == 0:
						brute_count += 1
						test_brute += 1
					pos_brute = wrapi(pos_brute, 0, 100)
				if steps >= pos:
					if pos:
						real_count += 1
						test_real += 1
					var steps_left_after_first_zero: int = steps - pos
					real_count += steps_left_after_first_zero / 100
					test_real += steps_left_after_first_zero / 100
				pos -= steps
			else:
				for step in steps:
					pos_brute += 1
					if pos_brute == 100:
						brute_count += 1
						test_brute += 1
					pos_brute = wrapi(pos_brute, 0, 100)
				if steps >= (100 - pos):
					if pos != 100:
						real_count += 1
						test_real += 1
					var steps_left_after_first_zero: int = steps - (100 - pos)
					real_count += steps_left_after_first_zero / 100
					test_real += steps_left_after_first_zero / 100
				pos += steps
			
			if test_brute != test_real:
				prints(line, "failed")
				prints("BRUTE:", old_pos_brute, "->", pos_brute, "-", test_brute)
				prints("REAL:", old_pos_real, "->", pos, "-", test_real)
			
			#if pos_brute != pos:
				#pass
			
			if pos == 0:
				count += 1
	
	print(count)
	print(real_count)
	print(brute_count)
