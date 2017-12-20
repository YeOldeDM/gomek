extends Node2D

const DIRECTIONS = [
	Vector2(0,-1),
	Vector2(1,-1),
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(-1,-1)
	]


var unit_name = "BOB" setget _set_unit_name

var team_color = Color(0,1,0) setget _set_team_color
var camo_color = Color(1,1,1) setget _set_camo_color


# Legs/Base facing
var facing = 0 setget _set_facing
# Torso/Turret facing
var torso_facing = 0 setget _set_torso_facing



onready var map = get_parent()
#onready var offset = map.cell_size / 2
var offset = Vector2()


# Reference to MekUnit class this mini represents
# Set by my spawner
var data	


# By-Turn transient data.
var turn_data = {
	"movement":	{
		"motive":	"idle",
		"MP_spent":	0,
		"hexes_moved":	0,
		"actions":	[],
		},
	"firing":	{
		"weapons_fired":	[],
		},
	"heat":	{
		"generated": 0,
		"sinks":	0,
		},
	}




func get_map_position():
	return map.world_to_map( position )

func set_map_position( cell ):
	position = map.map_to_world( cell ) + offset


func turn_right():
	var new_facing = self.facing + 1
	if new_facing > 5:	new_facing -= 5
	self.facing = new_facing

func turn_left():
	var new_facing = self.facing - 1
	if new_facing < 0:	new_facing += 5
	self.facing = new_facing

func torso_twist_right():
	self.torso_facing = 1

func torso_twist_left():
	self.torso_facing = -1

func torso_center():
	self.torso_facing = 0
	

func _ready():
	if map and 'cell_size' in map:
		offset = map.cell_size / 2

func _set_unit_name( what ):
	unit_name = what
	$Stats/Name.text = what


func _set_camo_color( what ):
	camo_color = what
	$Base.self_modulate = what
	$Base/Turret.self_modulate = what

func _set_team_color( what ):
	team_color = what
	$Base/BaseArrow.self_modulate = what
	$Base/Turret/TurretArrow.self_modulate = what
	$Stats/Name.set("custom_colors/font_color", what )

func _set_facing( what ):
	facing = what
	var f = 60 * what
	if $Base:
		$Base.rotation_degrees = f

func _set_torso_facing( what ):
	torso_facing = what
	var f = 60 * what
	if $Turret:
		$Turret.rotation_degrees = f
