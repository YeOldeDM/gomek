extends TileMap

#	MANAGE ALL THE UNIT NODES ON THE BOARD	#

func add_unit( cell=Vector2(), facing=0, data=null ):
	var mini = preload("res://minis/MekMini.tscn").instance()
	add_child(mini)
	mini.facing = facing
	mini.call_deferred("set_map_position", cell)
	return mini


