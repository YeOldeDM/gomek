extends ScrollContainer

func _ready():
	Forces.connect("units_changed", self, "_on_Forces_units_changed")

func _on_Forces_units_changed():
	print("Units Changed!!!")
	while $Box.get_child_count() > 0:
		$Box.get_child(0).free()
	
	# sort units by team
	var units = []
	for team in Forces.teams:
		units.append([])
	for unit in Forces.units:
		units[unit.team].append(unit)
	
	for team in units:
		for unit in team:
			add_unit_button(unit)
	
func add_unit_button(unit):
	var button = preload("res://battle/BattleSetup/UnitButton.tscn").instance()
	$Box.add_child(button)
	button.assign(unit)
	button.connect("toggled", self, "_on_UnitButton_toggled", [button])


func _on_UnitButton_toggled(toggled, who):
	for node in $Box.get_children():
		if node != who:
			node.pressed = false