extends WindowDialog

onready var tree = $"Box/Contents/Main/Box/Tree"
onready var teamlist = $"Box/Options/Team"

onready var uniticon = $Box/Contents/Main/Box/Top/UnitIcon

func create_unit():
	var sel = tree.get_selected()
	if !sel:
		OS.alert("No unit selected!")
		return ERR_UNCONFIGURED
	var pilot_name = $Box/Contents/Main/Box/Top/Box/PilotName/PilotNameEdit.text
	if pilot_name == "":
		OS.alert("Pilot needs a name!")
		return ERR_UNCONFIGURED
	var pilot_skills = {
		"Gunnery":	$Box/Contents/Main/Box/Top/Box/PilotSkill/GunneryEdit.value,
		"Piloting":	$Box/Contents/Main/Box/Top/Box/PilotSkill/PilotingEdit.value,
		}
	
	var pilot = Forces.create_pilot( pilot_name, pilot_skills )
	var key = sel.get_metadata(0)
	if !key in GameFiles.units:
		OS.alert("No Data found for unit %s" % key, "FUUUUUUUUU")
		return ERR_FILE_NOT_FOUND
	var data = sel.get_metadata(0)
	var team = teamlist.selected
	
	Forces.add_unit( data, team, pilot )
	get_parent().get_node("Box/Main/Units/Box/Left/Box/TeamSetup").draw_teamlist()
	return OK

func setup_tree():
	tree.set_hide_root(true)
	tree.set_select_mode(tree.SELECT_ROW)
	tree.set_column_titles_visible(true)

	tree.set_columns(6)
	tree.set_column_title(0, "Chassis")
	tree.set_column_title(1, "Model")
	tree.set_column_title(2, "Tonnage")
	tree.set_column_title(3, "Year")
	tree.set_column_title(4, "BV")
	tree.set_column_title(5, "Cost")
	
	for i in range(6):
		tree.set_column_expand(i, true)


func list_teams():
	teamlist.clear()
	for team in Forces.teams:
		print(team.name, Forces.teams.find(team))
		teamlist.add_item(team.name, Forces.teams.find(team))
	if !Forces.teams.empty():
		uniticon.modulate = Forces.teams[0].color
	

func draw_tree(sort_key="Chassis"):
	var list = []
	for unit in GameFiles.units:
		list.append(unit)
	list = sort_units(list, sort_key)
	tree.clear()
	var root = tree.create_item()
	for unit in list:
		prints("Add",unit)
		var u = GameFiles.units[unit]
		prints("made",u.Chassis)
		var item = tree.create_item( root )
		item.set_metadata(0,unit)
		item.set_text(0, u.Chassis)
		item.set_text(1, u.Model)
		item.set_text(2, str(u.Mass))
		item.set_text(3, str(u.Year))
		item.set_text(4, Format.number(u["Custom BV"]))
		item.set_text(5, "$"+Format.number(u["Custom Cost"]))


func draw_data_dump(data):
	var txt = "[b]%s %s[/b]\n" % [data.Chassis, data.Model]
	txt += data.TechBase+"\n"
	txt += "%s tons\n BV:%s\n Cost:%s C-Bills\n\n" % [str(data.Mass), Format.number(data["Custom BV"]), Format.number(data["Custom Cost"])]
	txt += "Movement: %s" % data["Walk MP"]
	if "Jump MP" in data:
		if data["Jump MP"] > 0:
			txt += "/"+str(data["Jump MP"])+"\n"
		else:
			txt += "\n"
	else:
		txt += "\n"
	txt += "Engine: %s %s\n" % [str( int(data.Mass) * int(data["Walk MP"]) ), data["Engine"] ]
	txt += "Heat Sinks: %s %s\n" % [str( data["Heat Sinks"].count ), data["Heat Sinks"].type ]
	txt += "\n\n"
	txt += "[b]Armor[/b]\n"
	txt += "               int.		armor\n"
	var internal = BT.get_internal_structure( data.Mass )
	txt += "Head           %s			%s\n" % [ str(internal.Head), str(data["Armor Points"].HD) ] 
	txt += "Center Torso   %s			%s(%s)\n" % [ str(internal.CenterTorso), str(data["Armor Points"].CT), str(data["Armor Points"].CTR)  ] 
	txt += "Left Torso     %s			%s(%s)\n" % [ str(internal.SideTorso), str(data["Armor Points"].LT), str(data["Armor Points"].LTR)  ] 
	txt += "Right Torso    %s			%s(%s)\n" % [ str(internal.SideTorso), str(data["Armor Points"].RT), str(data["Armor Points"].RTR)  ] 
	txt += "Left Arm       %s			%s\n" % [ str(internal.Arm), str(data["Armor Points"].LA) ] 
	txt += "Right Arm      %s			%s\n" % [ str(internal.Arm), str(data["Armor Points"].RA) ] 
	txt += "Left Leg       %s			%s\n" % [ str(internal.Leg), str(data["Armor Points"].LL) ] 
	txt += "Right Leg      %s			%s\n" % [ str(internal.Leg), str(data["Armor Points"].RL) ] 
	
	txt += "\n"
	
	var has_weapons = false
	var has_ammo = false
	var has_equipment = false
	for entry in data.Equipment:
		if "Weapon" in entry:
			has_weapons = true
		if "Ammo" in entry:
			has_ammo = true
		if "Equipment" in entry:
			has_equipment = true
	if has_weapons:
		txt += "\n[b]Weapons[/b]\n"
		for entry in data.Equipment:
			if "Weapon" in entry:
				txt += "%s:%s\n" % [entry.Weapon, entry.Slot]
	if has_ammo:
		txt += "\n[b]Ammunition[/b]\n"
		for entry in data.Equipment:
			if "Ammo" in entry:
				txt += "%s: %s" % [entry.Ammo, entry.Slot]
				if entry.Ammo in GameFiles.equipment:
					var ammo = GameFiles.equipment[entry.Ammo].AmmoCount
					txt += " %s rounds" % str(ammo)
				txt += "\n"
	$Box/Contents/UnitData.bbcode_text = txt



func sort_units(list, sort_key):
	prints("Sorting by",sort_key)
	list.sort_custom(self, "_sort_by_"+sort_key)
	return list

func _sort_by_Chassis(a,b):
	var comp = [GameFiles.units[a].Chassis, GameFiles.units[b].Chassis]
	comp.sort()
	return comp[0] == GameFiles.units[a].Chassis

func _sort_by_Model(a,b):
	var comp = [GameFiles.units[a].Model, GameFiles.units[b].Model]
	comp.sort()
	return comp[0] == GameFiles.units[a].Model

func _sort_by_Tonnage(a,b):
	print( typeof( GameFiles.units[a].Mass ) )
	return GameFiles.units[a].Mass < GameFiles.units[b].Mass

func _sort_by_Year(a,b):
	return GameFiles.units[a].Year < GameFiles.units[b].Year

func _sort_by_BV(a,b):
	return GameFiles.units[a]["Custom BV"] < GameFiles.units[b]["Custom BV"]

func _sort_by_Cost(a,b):
	return GameFiles.units[a]["Custom Cost"] < GameFiles.units[b]["Custom Cost"]

func _on_AddUnitWindow_about_to_show():
	draw_tree()
	list_teams()
	


func _ready():
	setup_tree()



func _on_Tree_item_selected():
	var sel = tree.get_selected()
	var meta = sel.get_metadata(0)
	var data = GameFiles.units[meta]
	var unit_img = GameFiles.get_unit_graphic(data)
	uniticon.texture = unit_img
	draw_data_dump(GameFiles.units[meta])

func _on_Tree_column_title_pressed( column ):
	draw_tree( tree.get_column_title(column) )


func _on_Team_item_selected( ID ):
	uniticon.modulate = Forces.teams[ID].color


func _on_Select_pressed():
	var err = create_unit()



func _on_SelectClose_pressed():
	var err = create_unit()
	if err == OK:
		hide()


func _on_Close_pressed():
	hide()
