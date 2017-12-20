extends WindowDialog

var team

func setup( tidx ):
	self.team = Forces.teams[tidx]
	
	$Box/Contents/NameEdit.text = team.name
	$Box/Contents/ColorEdit.color = team.color
	$Box/Contents/ZoneEdit.select( team.start )
	


func _on_Apply_pressed():
	team.name = $Box/Contents/NameEdit.text
	team.color = $Box/Contents/ColorEdit.color
	team.start = $Box/Contents/ZoneEdit.get_selected_id()
	
	Forces.emit_signal("teams_changed")
	self.team = null
	hide()
