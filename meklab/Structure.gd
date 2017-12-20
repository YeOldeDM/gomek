extends HBoxContainer

onready var lab = $"../../../../"
onready var SummaryTree = $Center/Box/Summary/Box/SummaryTree

func _ready():
	SummaryTree.set_hide_root(true)
	SummaryTree.set_columns(3)
	SummaryTree.set_column_titles_visible(true)
	SummaryTree.set_column_title(0, "Item")
	SummaryTree.set_column_title(1, "Mass")
	SummaryTree.set_column_title(2, "Space")
	SummaryTree.set_column_expand(1,false)
	SummaryTree.set_column_min_width(1,100)
	SummaryTree.set_column_expand(2,false)
	SummaryTree.set_column_min_width(2,100)
	draw_summary_tree()


func draw_summary_tree():
	SummaryTree.clear()
	var root = SummaryTree.create_item()
	
	var structure = SummaryTree.create_item(root)
	structure.set_text(0, "Chassis")
	structure.set_text(1, str( lab.get_internal_structure_mass() ).pad_decimals(1) )
	structure.set_text(2, "0")
	
	var engine = SummaryTree.create_item(root)
	engine.set_text(0, "%s Fusion Engine" % str( lab.get_engine_rating() ) )
	engine.set_text(1, str( lab.get_engine_mass() ).pad_decimals(1) )
	engine.set_text(2, "6")
	
	var gyro = SummaryTree.create_item(root)
	gyro.set_text(0, "Gyro")
	gyro.set_text(1, str( lab.get_gyro_mass() ).pad_decimals(1) )
	gyro.set_text(2, "4")
	
	var cockpit = SummaryTree.create_item(root)
	cockpit.set_text(0, "Cockpit")
	cockpit.set_text(1, "3.0")
	cockpit.set_text(2, "5")
	
	if lab.working["Jump Jets"].Count > 0:
		var jets = SummaryTree.create_item(root)
		jets.set_text(0, "Jump Jets")
		jets.set_text(1, lab.get_jump_jet_mass().pad_decimals(1) )
		jets.set_text(2, str( lab.working["Jump Jets"].Count ) )
	
	if lab.working["Heat Sinks"].Count > lab.get_engine_free_heatsinks():
		var sinks = SummaryTree.create_item(root)
		sinks.set_text(0, "Heat Sinks")
		sinks.set_text(1, str( lab.get_heatsink_mass() ).pad_decimals(1) )
		sinks.set_text(2, str( lab.get_nonfree_heatsinks() ) )
	
	var armor = SummaryTree.create_item(root)
	armor.set_text(0, "Armor")
	armor.set_text(1, str( lab.working.Armor.Mass).pad_decimals(1) )
	armor.set_text(2, "0")
	
	
	