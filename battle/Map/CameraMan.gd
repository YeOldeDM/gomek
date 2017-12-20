extends KinematicBody2D

var dragging = false
var mo


func _physics_process(delta):
	var CAMDRAG = Input.is_mouse_button_pressed( BUTTON_MIDDLE )
	
	if CAMDRAG:
		if !dragging:	mo = get_viewport().get_mouse_position()
		var mp = get_viewport().get_mouse_position()
		move_and_collide( -(mp - mo) * $Camera.zoom )
		mo = mp
	dragging = CAMDRAG