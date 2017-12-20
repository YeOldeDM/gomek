extends WindowDialog


func _ready():
	$Box/Fields/NameEdit.set_text("New Team")
	$Box/Fields/StartEdit.selected = 0



func _on_NewTeamOK_pressed():
	var name = $Box/Fields/NameEdit.get_text()
	var start = $Box/Fields/StartEdit.get_selected()
	var color = $Box/Fields/ColorEdit.color
	Forces.add_team( name, color, start )
	hide()


func _on_NewTeamCancel_pressed():
	hide()
