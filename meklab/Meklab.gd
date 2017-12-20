extends Control

signal chassis_changed( to )
signal model_changed( to )
signal tech_base_changed( to )
signal config_changed( to )
signal year_changed( to )
signal mass_changed( to )
signal MP_changed( to )
signal engine_type_changed( to )
signal structure_type_changed( to )
signal gyro_type_changed( to )
signal cockpit_type_changed( to )
signal myomar_type_changed( to )
signal heat_sinks_changed( to )
signal jump_jets_changed( to )
signal armor_changed( to )

signal equipment_changed()
signal critical_slots_changed()

var working = {
	"Chassis":	"NewMek",
	"Model":	"ABC-0",
	"Tech Base":	"Inner Sphere",
	"Config":	"Biped",
	"Year":		2439,
	"Mass":		20,
	"MP":		1,
	"Engine":	"FusionStandard",
	"Structure":	"Standard",
	"Gyro":			"Standard",
	"Cockpit":	"Primitive",
	"Myomar":	"Standard",
	"Heat Sinks":	{"Count":10, "Type":"Single"},
	"Jump Jets":	{"Count":0, "Type":"Standard"},
	"Armor":	{"Mass":0.0, "Type":"Standard"},
	"Armor Points": {
		"LA":0, "RA":0, "RT":0, "LT":0, "CT":0, "RTR":0, "LTR":0, "CTR":0, "HD":0, "RL":0, "LL":0
		},
	"Equipment": [],
	"Critical Slots": {
		"LA":	["Shoulder","Upper Arm","Lower Arm","Hand",null,null,null,null,null,null,null,null,],
		"RA":	["Shoulder","Upper Arm","Lower Arm","Hand",null,null,null,null,null,null,null,null,],
		"LT":	[null,null,null,null,null,null,null,null,null,null,null,null,],
		"RT":	[null,null,null,null,null,null,null,null,null,null,null,null,],
		"CT":	["Engine","Engine","Engine","Gyro","Gyro","Gyro","Gyro","Engine","Engine","Engine",null,null],
		"HD":	["LifeSupport","Sensors","Cockpit",null,"Sensors","LifeSupport"],
		"LL":	["Hip","Upper Leg", "Lower Leg", "Foot", null,null],
		"RL":	["Hip","Upper Leg", "Lower Leg", "Foot", null,null],
	},
	
}

func get_internal_structure_mass():
	var mass = working.Mass * 0.1
	return mass

func get_engine_rating():
	return working.Mass * working.MP
	
func get_engine_mass():
	return BT.get_engine_mass( get_engine_rating() )


func get_engine_free_heatsinks():
	return int( get_engine_rating() / 25 )

func get_nonfree_heatsinks():
	return working["Heat Sinks"].Count - get_engine_free_heatsinks()

func get_heatsink_mass():
	return working["Heat Sinks"].Count - 10

func get_gyro_mass():
	return max(1.0, ceil( get_engine_rating() / 100.0 ))

func get_jump_jet_mass():
	var mass_per = 0.5
	if working.Mass >= 60:
		mass_per = 1.0
	elif working.Mass >= 90:
		mass_per = 2.0
	
	return mass_per * working["Jump Jets"].Count

func set_chassis( what ):
	working.Chassis = str(what)
	emit_signal( "chassis_changed", working.Chassis )

func set_model( what ):
	working.Model = str(what)
	emit_signal( "model_changed", working.Model )

func set_tech_base( what ):
	working["Tech Base"] = what
	emit_signal( "tech_base_changed", working["Tech Base"] )

func set_config( what ):
	working.Config = what
	emit_signal( "config_changed", working.Config )

func set_year( what ):
	working.Year = int(what)
	emit_signal( "year_changed", working.Year )

func set_mass( what ):
	working.Mass = int(what)
	emit_signal( "mass_changed", working.Mass )

func set_MP( what ):
	working.MP = int(what)
	emit_signal( "MP_changed", working.MP )

func set_engine_type( what ):
	working["Engine"] = what
	emit_signal( "engine_type_changed", working["Engine"] )

func set_structure_type( what ):
	working.Structure = what
	emit_signal( "structure_type_changed", working.Structure )

func set_gyro_type( what ):
	working.Gyro = what
	emit_signal( "gyro_type_changed", working.Gyro )

func set_cockpit_type( what ):
	working.Cockpit = what
	emit_signal( "cockpit_type_changed", working.Cockpit )

func set_myomar_type( what ):
	working.Myomar = what
	emit_signal( "myomar_type_changed", working.Myomar )

func set_armor_mass( what ):
	working.Armor.Mass = what
	emit_signal( "armor_changed" )
func set_armor_type( what ):
	working.Armor.Type = what
	emit_signal( "armor_changed" )

func set_jump_jet_count( what ):
	working["jump Jets"].Count = what
	emit_signal( "jump_jets_changed" )

func set_jump_jet_type( what ):
	working["Jump Jets"].Type = what
	emit_signal( "jump_jets_changed" )

func set_heat_sink_count( what ):
	working["Heat Sinks"].Count = what
	emit_signal( "heat_sinks_changed" )


func _on_TechBaseEdit_item_selected( ID ):
	var base = ["Inner Sphere","Clan"][ID]
	set_tech_base(base)


func _on_ChassisEdit_text_changed( text ):
	set_chassis( text )


func _on_ModelEdit_text_changed( text ):
	set_model( text )


func _on_YearEdit_value_changed( value ):
	set_year( value )



func _on_MassEdit_value_changed( value ):
	set_mass( value )


func _on_MotiveEdit_item_selected( ID ):
	var value = ["Bipedal"][ID]
	set_config(value)


func _on_StructureEdit_item_selected( ID ):
	var value = ["Standard", "EndoSteel"][ID]
	set_structure_type( value )


func _on_EngineEdit_item_selected( ID ):
	var value = ["FusionStandard", "FusionXL"][ID]
	set_engine_type( value )


func _on_GyroEdit_item_selected( ID ):
	var value = ["Standard"][ID]
	set_gyro_type( value )


func _on_CockpitEdit_item_selected( ID ):
	var value = ["Standard", "Primitive"][ID]
	set_cockpit_type( value )


func _on_MyomarEdit_item_selected( ID ):
	var value = ["Standard","MASC","TSM"][ID]
	set_myomar_type( value )


func _on_ArmorMassEdit_value_changed( value ):
	set_armor_mass( value )


func _on_ArmorTypeEdit_item_selected( ID ):
	var value = ["Standard", "Ferro-Fibrous"][ID]
	set_armor_type( value )


func _on_WalkMPEdit_value_changed( value ):
	set_MP( value )


func _on_JumpMPEdit_value_changed( value ):
	set_jump_jet_count( value )


func _on_CountEdit_value_changed( value ):
	set_heat_sink_count( value )
