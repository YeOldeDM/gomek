extends Node2D

enum Phases{
	Initiative,
	Movement,
	Attack,
	Melee,
	Heat,
	End,
	}


var deployed = false

var turn = 0

var phase = Phases.Initiative


var in_gui = false

func _ready():
	$Map.connect("cell_selected", $GUI/HexInfo, "show_hex_info")

	for node in $GUI.get_children():
		if node.has_node("MouseBox"):
			node.get_node("MouseBox").connect("mouse_entered", $Map, "set", ["in_gui", true])
			node.get_node("MouseBox").connect("mouse_exited", $Map, "set", ["in_gui", false])
