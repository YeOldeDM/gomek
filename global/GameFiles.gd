extends Node

signal unit_list_built()
signal board_list_built()

const UNIT_EXT = ".mrof"
const BOARD_EXT = ".board"
const UNITS_PATH = "res://data/units"
const BOARDS_PATH = "res://data/boards"

var units = {}

var boards = {}

var equipment = {}




# Build master equipment dictionary 
# From .csv file
func build_equipment_dict():
	var file = File.new()
	file.open("res://data/tables/equipment.csv", File.READ)
	var lines = []
	while !file.eof_reached():
		var line = file.get_line()
		if !line.begins_with("#") and !line.begins_with(":"):
			lines.append(line.split(":"))
	# Construct keys from line 0
	var keys = lines[0]
	# Go thru all other lines
	for i in range(1, lines.size()):
		var line = lines[i]
		var eq = {}
		for k in range(keys.size()):
			if line.size() > k:
				var key = keys[k]
				var val = line[k]
				if key == "Tags":
					val = Array( val.split(",") )
				elif key == "Damage" and !val.is_valid_integer():
					val = val.split(",")
					var dmg = int(val[0])
					var cls = val[1].split("/")
					var grouping = int( cls[0].replace("C","") )
					var cluster = int( cls[1] )
					val = [dmg, grouping, cluster]
				elif val.is_valid_integer(): val = int(val)
				elif val == "": val = null


				eq[key] = val

		if "Name" in eq:
			equipment[ eq.Name ] = eq
	file.close()







func get_unit_graphic(unit):
	var name = unit.Chassis +" "+ unit.Model
	var file = File.new()
	var img = file.file_exists("res://assets/graphics/units/meks/%s.png" % name)
	if !img:
		var generic = file.file_exists("res://assets/graphics/units/meks/%s.png" % unit.Chassis)
		if generic:
			img = load("res://assets/graphics/units/meks/%s.png" % unit.Chassis)
		else:
			var data = units[name]
			var size = "light"
			if data.Mass <= 35:
				size = "light"
			elif data.Mass <= 55:
				size = "medium"
			elif data.Mass <= 75:
				size = "heavy"
			else:
				size = "assault"
			img = load("res://assets/graphics/units/defaults/default_"+size+".png")
	else:
		img = load("res://assets/graphics/units/meks/%s.png" % name)
	return img

func build_units():
	var files = find_files_in_dir( UNIT_EXT, UNITS_PATH )
	
	var unit_array = []
	for path in files:

		var data = ROF.mrof_to_dict( path )
		assert typeof(data) == TYPE_DICTIONARY
		unit_array.append(data)

	for entry in unit_array:
		var key = entry.Chassis.strip_edges()+" "+entry.Model.strip_edges()
		units[key] = entry
	print("Loaded %s Unit File(s)!" % str(files.size()))







func build_board_list():
	var file_list = find_files_in_dir( BOARD_EXT, BOARDS_PATH )
	var file = File.new()
	for path in file_list:
		var map = parse_board_file( path )
		boards[map.name] = map
	prints("Loaded", boards.size(), "Board(s)!")
	emit_signal("board_list_built")

# Drill through path for all files that end with ext
func find_files_in_dir( ext, path ):
	var dir = Directory.new()
	var opened = dir.change_dir( path )
	if !opened == OK:
		return ERR_WTF
	var files = []
	dir.list_dir_begin(true,true)
	var file = dir.get_next()
	while file != "":
		if file.ends_with(ext):
			files.append("%s/%s" % [path, file])
		elif dir.current_is_dir():
			for f in find_files_in_dir( ext, "%s/%s" % [path, file] ):
				files.append( f )
		file = dir.get_next()
	dir.list_dir_end()
	
	return files






func parse_board_file( path ):
	var file = File.new()
	var opened = file.open( path, File.READ )
	var map = {"data":[]}
	map["name"] = path.split("/")[-1]
	while !file.eof_reached():
		var txt = file.get_line().split(" ")
		if txt[0] == "size":
			map["size"] = Vector2( int(txt[1]), int(txt[2]) )
		if txt[0] == "hex":
			var terrain = Array(txt[3].replace('"', "").split(":"))
			for word in terrain:
				if word.is_valid_integer():
					terrain[terrain.find(word)] = int(word)
			var cell = {
				"cell": Vector2( int(txt[1].left(2))-1, int(txt[1].right(2))-1 ),
				"elevation": int(txt[2]),
				"terrain":	terrain,
				}
			if terrain[0] == "water":
				cell.elevation -= int(terrain[1])
			map.data.append(cell)
	file.close()
	return map







func _ready():
	build_equipment_dict()
#	build_unit_list()
	build_units()
	build_board_list()



