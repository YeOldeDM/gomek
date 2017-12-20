extends Node

var engine_mass_table = {}

var internal_structure_table = {}

func roll_d6():
	return 1 + randi() % 6

func roll_d12():
	return roll_d6() + roll_d6()

func build_internal_structure_table():
	var file = File.new()
	file.open("res://data/tables/InternalStructure.csv", File.READ)
	var lines = []
	while !file.eof_reached():
		lines.append(file.get_line().split(":"))
	file.close()
	
	for line in lines:
		if line[0].is_valid_integer():
			internal_structure_table[int(line[0])] = {
					"Head":			3,
					"CenterTorso":	int(line[1]),
					"SideTorso":	int(line[2]),
					"Arm":			int(line[3]),
					"Leg":			int(line[4]),
					"MaxAP":		int(line[5])
					}
	

func build_engine_mass_table():
	var file = File.new()
	file.open("res://data/tables/EngineMass.csv", File.READ)
	
	var lines = []
	while !file.eof_reached():
		lines.append(file.get_line().split(":"))
	file.close()
	var keys = lines[0]
	for line in lines:
		if line[0].is_valid_integer():
			engine_mass_table[line[0]] = {"FusionStandard": float(line[1])}

	
func get_engine_mass( rating=20, type="FusionStandard" ):
	return engine_mass_table[str(rating)][type]

func get_internal_structure( mass=20 ):
	return internal_structure_table[mass]

func _ready():
	build_engine_mass_table()
	build_internal_structure_table()
	
