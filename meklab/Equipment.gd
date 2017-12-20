extends HBoxContainer

onready var EquipmentList = $Right/EquipmentList



func setup_equipment_list():
	EquipmentList.set_hide_root(true)
	var titles = ["Name", "Heat", "Damage", "MinRange", "ShortRange", "MedRange", "LongRange", "Mass", "Slots", "Ammo"]
	EquipmentList.set_column_titles_visible(true)
	EquipmentList.set_columns( titles.size() )
	EquipmentList.set_select_mode( Tree.SELECT_ROW )
	EquipmentList.set_column_expand(0,true)
	EquipmentList.set_column_min_width(0, 100)
	for i in range(1, 10):
		EquipmentList.set_column_expand(i, false)
		EquipmentList.set_column_min_width(i, 80)
	for t in titles:
		EquipmentList.set_column_title( titles.find(t), t )

func draw_equipment_list():
	EquipmentList.clear()
	var root = EquipmentList.create_item()
	
	for entry in GameFiles.equipment:
		var dat = GameFiles.equipment[entry]
		
		var shortrange_str = "1"
		if dat.ShortRange > 1:
			shortrange_str = "1-%s" % str(dat.ShortRange)
		var medrange_str = "2"
		if dat.MedRange != dat.ShortRange + 1:
			medrange_str = "%s-%s" % [str(dat.ShortRange+1), str(dat.MedRange)]
		var longrange_str = "3"
		if dat.LongRange != dat.MedRange + 1:
			longrange_str = "%s-%s" % [str(dat.MedRange+1), str(dat.LongRange)]
		
		var dmg_str = str(dat.Damage)
		if typeof(dat.Damage) == TYPE_ARRAY:
			dmg_str = "%sx(C%s/%s)" % [str(dat.Damage[0]), str(dat.Damage[1]), str(dat.Damage[2])]
		
		var itm = EquipmentList.create_item(root)
		print(dat)
		itm.set_text(0, str(dat.Name))
		itm.set_text(1, str(dat.Heat))
		itm.set_text(2, dmg_str)
		itm.set_text(3, str(dat.MinRange))
		itm.set_text(4, shortrange_str)
		itm.set_text(5, medrange_str)
		itm.set_text(6, longrange_str)
		itm.set_text(7, str(dat.Mass))
		itm.set_text(8, str(dat.Slots))
		itm.set_text(9, str(dat.AmmoCount))


func _ready():
	setup_equipment_list()
	draw_equipment_list()