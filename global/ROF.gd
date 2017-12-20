extends Node

# R.O.F. Singleton
# (ReadOut File)

# MechROF data
const mrof_template = {
		"Unit":			"Mech",
		"Chassis":		"Fekmek",
		"Model":		"XXX-69",
		"Version":		1.0,
		"Year":			1950,
		"Config":		"Bipedal",
		"TechBase":		"Inner Sphere",
		"Mass":			20,
		"Engine":		"Standard",
		"Structure":	"Standard",
		"Myomer":		"Standard",
		"Heat Sinks":	{
			"count":	10,
			"type":		"Single",
			},
		"Walk MP":		1,
		"Jump MP":		0,
		"Armor":		"Standard",
		"Armor Points":	{
			"LA":	0, "RA":	0,
			"LT":	0, "RT":	0,
			"CT":	0, "HD":	0,
			"LL":	0, "RL":	0,
			"RTR":	0,	"LTR":	0,
			"CTR":	0 },
		"Equipment":	[],
		"Critical Slots":	{
			"Left Arm": [
				"Shoulder","UpperArm","LowerArm","Hand","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				], 
			"Right Arm": [
				"Shoulder","UpperArm","LowerArm","Hand","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				], 
			"Left Torso": [
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				], 
			"Right Torso": [
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				],
			"Center Torso": [
				"Engine","Engine","Engine","Gyro","Gyro","Gyro","Gyro",
				"Engine","Engine","Engine","-Empty-","-Empty-",
				], 
			"Head": ["LifeSupport","Sensors","Cockpit","-Empty-","Sensors","LifeSupport"],
			"Left Leg": ["Hip","UpperLeg","LowerLeg","Foot","-Empty-","-Empty-"], 
			"Right Leg": ["Hip","UpperLeg","LowerLeg","Foot","-Empty-","-Empty-"],
			},
		"Custom BV":	0,
		"Custom Cost":	0,
	}

func mrof_to_dict( path ):
	var data = {
		"Unit":			"Mech",
		"Chassis":		"Fekmek",
		"Model":		"XXX-69",
		"Version":		1.0,
		"Year":			1950,
		"Config":		"Bipedal",
		"TechBase":		"Inner Sphere",
		"Mass":			20,
		"Engine":		"Standard",
		"Structure":	"Standard",
		"Myomer":		"Standard",
		"Heat Sinks":	{
			"count":	10,
			"type":		"Single",
			},
		"Walk MP":		1,
		"Jump MP":		0,
		"Armor":		"Standard",
		"Armor Points":	{
			"LA":	0, "RA":	0,
			"LT":	0, "RT":	0,
			"CT":	0, "HD":	0,
			"LL":	0, "RL":	0,
			"RTR":	0,	"LTR":	0,
			"CTR":	0 },
		"Equipment":	[],
		"Critical Slots":	{
			"Left Arm": [
				"Shoulder","UpperArm","LowerArm","Hand","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				], 
			"Right Arm": [
				"Shoulder","UpperArm","LowerArm","Hand","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				], 
			"Left Torso": [
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				], 
			"Right Torso": [
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				"-Empty-","-Empty-","-Empty-","-Empty-","-Empty-","-Empty-",
				],
			"Center Torso": [
				"Engine","Engine","Engine","Gyro","Gyro","Gyro","Gyro",
				"Engine","Engine","Engine","-Empty-","-Empty-",
				], 
			"Head": ["LifeSupport","Sensors","Cockpit","-Empty-","Sensors","LifeSupport"],
			"Left Leg": ["Hip","UpperLeg","LowerLeg","Foot","-Empty-","-Empty-"], 
			"Right Leg": ["Hip","UpperLeg","LowerLeg","Foot","-Empty-","-Empty-"],
			},
		"Custom BV":	0,
		"Custom Cost":	0,
	}
#	for key in mrof_template:
#		data[key] = mrof_template[key]
	var file = File.new()
	var opened = file.open(path, File.READ)
	if !opened == OK:
		print("OOPS!")
		return opened
	var txt = []
	while !file.eof_reached():
		txt.append(file.get_line().split(":"))
	file.close()
	for line in txt:
		# Parse Heat Sinks
		if line[0] == "Heat Sinks":
			var words = line[1].split(" ")
			var count = 10
			var type = "Single"
			if words[0].is_valid_integer():
				count = int(words[0])
				if words.size() > 1 and words[1] != "":
					type = words[1]
			data["Heat Sinks"].count = count
			data["Heat Sinks"].type = type
		
		# Parse Armor Points
		elif line[0] == "Armor Points":
			for i in range(1,12):
				var pline = txt[txt.find(line)+i]
				if pline[0] in data["Armor Points"]:
					data["Armor Points"][pline[0]] = int(pline[1])
		
		# Parse Equipment
		elif line[0] == "Equipment":
			var eq_lines = []
			var n = 1
			var l = txt[ txt.find( line ) + 1 ]
			while l[0].left(1).is_valid_integer():
				eq_lines.append(txt[txt.find(line) + n])
				n += 1
				l = txt[ txt.find( line ) + n ]
			for eq in eq_lines:
				var a = eq
				data.Equipment.append({a[1]:a[2],"Slot":a[3]})
			
		elif line[0] == "Critical Slots":
			for i in range(1,11):
				var cline = txt[txt.find(line)+i]
				if cline[0] in data["Critical Slots"]:
					for o in range(1, cline.size()):
						data["Critical Slots"] [cline[0]] [o-1] = cline[o]
		# Parse simple key/value pairs
		elif line[0] in data:
			var key = line[0].strip_edges()
			var val = line[1].strip_edges()
			if val.is_valid_integer():
				val = int(val)
			elif val.is_valid_float():
				val = float(val)
			data[key] = val


	return data



