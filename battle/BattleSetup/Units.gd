extends VBoxContainer



func get_selected_team():
	return $Box/Left/Box/TeamList.get_selected().get_metadata(0)


func get_selected_unit():
	for node in $Box/Right/Box/UnitList/Box.get_children():
		if node.pressed:
			return node.get_meta("unit")


func _on_AddUnit_pressed():
	get_owner().get_node("AddUnitWindow").popup()


func _on_RemoveUnit_pressed():
	var popup = ConfirmationDialog.new()
	popup.dialog_text = "Really remove this unit?"
	popup.connect("confirmed", self, "_on_RemoveUnit_confirmed",[popup])
	popup.get_cancel().connect("pressed", popup, "queue_free")
	add_child(popup)
	popup.popup_centered()

func _on_RemoveUnit_confirmed(popup):
	var unit = get_selected_unit()
	Forces.remove_unit(unit)
	popup.queue_free()


func _on_ClearUnits_pressed():
	var popup = ConfirmationDialog.new()
	popup.dialog_text = "This will remove all units. Are you sure??"
	popup.connect("confirmed", self, "_on_ClearUnits_confirmed", [popup])
	popup.get_cancel().connect("pressed", popup, "queue_free")
	add_child(popup)
	popup.popup_centered()

func _on_ClearUnits_confirmed(popup):
	Forces.clear_all_units()
	popup.queue_free()


func _on_ClearTeamUnits_pressed():
	var popup = ConfirmationDialog.new()
	popup.dialog_text = "Remove all units from the selected team?"
	popup.connect("confirmed", self, "_on_ClearTeamUnits_confirmed", [popup])
	popup.get_cancel().connect("pressed", popup, "queue_free")
	add_child(popup)
	popup.popup_centered()

func _on_CearTeamUnits_confirmed(popup):
	Forces.clear_units_in_team( get_selected_team() )
	popup.queue_free()


func _on_Color_color_changed( color ):
	var team = get_selected_team()
	if team:
		Forces.teams[team].color = color
		Forces.emit_signal("teams_changed")
