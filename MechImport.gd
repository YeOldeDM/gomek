extends Node

func mtf_to_rof( mtf_path ):
	var data = mtf_to_dict( mtf_path )
#	if data == ERR_FILE_NOT_FOUND:
#		return ERR_FILE_NOT_FOUND
	var name = "%s %s" % [data.Chassis, data.Model]
	var rof_path = "res://data/units/mechs/%s.rof" % name
	var file = File.new()
	var opened = file.open( rof_path, File.WRITE )
	if !opened == OK:
		return ERR_WTF
	file.store_line( to_json( data ) )
	
	file.close()
	print( "!!!  Wrote new readout file to %s  !!!" % rof_path )
	return OK


func mtf_to_dict( path ):
	var file = File.new()
	var opened = file.open( path, File.READ )
	if !opened == OK:
		return ERR_FILE_NOT_FOUND
	# Taken from ROD singleton
	var dict = ROF.mech_rod_template
	
	# Parse json data to txt array
	var txt = []
	while !file.eof_reached():
		txt.append( file.get_line() )
	
	# Parse absolute lines (not defined by key:value pair, but always exists on the same line in every mtf)
	dict.Chassis = txt[1]
	dict.Model = txt[2]
	
	# parse key:value pairs
	for line in txt:
		if line.find(":") >= 0:
			var words = line.split(":")
			
			# parse weapons list
			if words[0] == "Weapons":
				var list = []
				var i = 1
				while txt[ txt.find(line) + i] != "":
					var t = txt[ txt.find(line) + i].split(",")
					list.append({"Weapon": t[0], "Slot": t[1]})
					i += 1
				dict.Weapons = list
			# parse Engine data
			elif words[0] == "Engine":
				var s = words[1].split(" ")
				dict["Engine"].rating = int(s[0])
				dict["Engine"].type = s[1]
			# parse Heat Sink data
			elif words[0] == "Heat Sinks":
				var s = words[1].split(" ")
				dict["Heat Sinks"].count = int(s[0])
				dict["Heat Sinks"].type = s[1]
			# parse simple data
			elif words[0] in dict:
				var value = words[1]
				# parse numbers as ints
				if words[1].is_valid_integer():
					value = int(value)
				dict[words[0]] = value
			# parse Armor data
			if words[0].ends_with(" Armor"):
				var spot = words[0].split(" ")[0]
				if spot in dict["Armor Points"]:
					dict["Armor Points"][spot] = int(words[1])
			# parse Critical Slots data
			if words[0] in dict["Critical Slots"]:
				for i in range(12):
					var slot = txt[i+txt.find(line)+1]
					dict["Critical Slots"][words[0]].append( slot )

	file.close()
	return dict
