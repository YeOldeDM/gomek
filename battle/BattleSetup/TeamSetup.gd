extends PanelContainer

onready var TeamList = $"../TeamList"

const START_ZONES = [
	"any",
	"north",
	"east",
	"sound",
	"west"
	]

func setup_teamlist():
	var tree = TeamList
	tree.set_hide_root(true)
	tree.set_column_titles_visible(true)
	tree.set_select_mode(tree.SELECT_ROW)
	tree.set_allow_rmb_select(true)
	
	tree.set_columns(5)
	tree.set_column_title(0, "Team")
	tree.set_column_title(1, "Start")
	tree.set_column_title(2, "BV")
	tree.set_column_title(3, "Tonnage")
	tree.set_column_title(4, "Cost")

func draw_teamlist():
	var tree = TeamList
	tree.clear()
	var root = tree.create_item()
	pass
	for team in Forces.teams:
		var item = tree.create_item( root )
		var t = Forces.teams.find(team)
		item.set_metadata( 0, t )
		item.set_text(0, team.name)
		item.set_custom_bg_color(0,team.color)
		item.set_custom_color(0, team.color.inverted())
		item.set_text(1, START_ZONES[team.start])
		item.set_text(2, Format.number(Forces.get_team_BV(t)))
		item.set_text(3, Format.number(Forces.get_team_tonnage(t))+"t")
		item.set_text(4, "$"+Format.number(Forces.get_team_cost(t)))



func _ready():
	setup_teamlist()
	Forces.connect("teams_changed", self, "draw_teamlist")
	Forces.connect("units_changed", self, "draw_teamlist")


func _on_AddTeam_pressed():
	get_owner().get_node("AddTeamWindow").popup()


func _on_TeamList_item_selected():
	var team = TeamList.get_selected().get_metadata(0)
	var t = Forces.teams[team]
	$Box/Actions/Name.text = t.name
#	$"Box/Camo/Color".color = t.color


func _on_RemoveTeam_pressed():
	var win = ConfirmationDialog.new()
	var team = TeamList.get_selected().get_metadata(0)
	win.get_cancel().connect("pressed", win, "queue_free")
	win.connect("confirmed", Forces, "remove_team", [team])
#	win.window_title("Confirm, plz!")
	add_child(win)
	win.dialog_text = "Are you sure you want to remove this team?"
	win.popup_centered()



func _on_TeamList_item_rmb_selected( position ):
	var team = TeamList.get_item_at_position( position )
	if team:
		var menu = PopupMenu.new()
		add_child(menu)
		menu.rect_position = get_global_mouse_position() + Vector2(8,0)
		menu.add_item("Edit..", 0 )
		menu.add_item("Delete..", 1)
		menu.add_item("Clear Units..", 2)
		menu.connect("id_pressed", self, "_on_TeamMenu_id_pressed", [team.get_metadata(0), menu])
		menu.popup()


func _on_TeamMenu_id_pressed( id, team, from_menu ):
	from_menu.queue_free()
	if id == 0:
		get_owner().get_node("EditTeamWindow").popup()
		get_owner().get_node("EditTeamWindow").setup( team )
	elif id == 1:
		pass
	elif id == 2:
		pass


