extends Control


const PRACTICE: Array[String] = [
							"..@@.@@@@.",
							"@@@.@.@.@@",
							"@@@@@.@.@@",
							"@.@@@@..@.",
							"@@.@@@@.@@",
							".@@@@@@@.@",
							".@.@.@.@@@",
							"@.@@@.@@@@",
							".@@@@@@@@.",
							"@.@.@@@.@."]


var practicing := false

var data: Array[PackedStringArray] = []
var data_size: Vector2


func _ready() -> void:
	var total: int = 0
	var initial_tp_count: int = 0
	if practicing:
		for line: String in PRACTICE:
			data.append(line.split(""))
	else:
		var file := FileAccess.open("res://day 4/input.txt", FileAccess.READ)
		while file.get_position() < file.get_length():
			var line: String = file.get_line()
			data.append(line.split(""))
	
	data_size = Vector2(data[0].size(), data.size())
	
	for y: int in data_size.y:
		for x: int in data_size.x:
			if tp(x, y):
				initial_tp_count += 1
				if can_remove(x, y):
					total += 1
	
	print(total)
	
	var removing := true
	var total_removed: int = 0
	
	while removing:
		var to_remove: Array[Vector2i] = []
		for y: int in data_size.y:
			for x: int in data_size.x:
				if tp(x, y):
					if can_remove(x, y):
						to_remove.append(Vector2i(x, y))
		if to_remove.size():
			total_removed += to_remove.size()
			print("removing %s" % to_remove.size())
			remove(to_remove)
		else:
			removing = false
	
	print(str(total_removed) + " out of " + str(initial_tp_count))


func remove(tps: Array[Vector2i]):
	for tp_to_remove: Vector2 in tps:
		data[tp_to_remove.y][tp_to_remove.x] = "."


func can_remove(x: int , y: int) -> bool:
	var adjacent: int = 0
	for x0: int in [-1, 0, 1]:
		for y0: int in [-1, 0, 1]:
			if not (x0 == 0 and y0 == 0):
				if tp(x + x0, y + y0):
					adjacent += 1
	return adjacent < 4


func tp(x: int, y: int) -> bool:
	if x >= data_size.x or x < 0 or y >= data_size.y or y < 0:
		return false
	return data[y][x] == "@"
