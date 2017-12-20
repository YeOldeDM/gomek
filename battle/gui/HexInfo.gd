extends PanelContainer

const TERRAIN = [
	"water", "light woods", "heavy woods", "rough", "pavement"
	]

func _ready():
	pass

func show_hex_info( hexcell ):
	var coords = hexcell.coords
	var ele = hexcell.elevation
	var terrain = hexcell.get_terrain_string()
	if terrain == "water":
		ele += hexcell.terrain[1]
	$Box/Title.text = "HEX#%s" % coords
	$Box/Elevation.text = "Elevation: %s" % str(ele)
	var ter_txt = terrain
	if terrain == "water":
		ter_txt += " (Depth %s)" % str(hexcell.terrain[1])
	$Box/Terrain.text = ter_txt
	
	$ElevationMap.set_cell(0,0, ele+6)
	var tidx = -1
	if terrain in TERRAIN:
		tidx = TERRAIN.find(terrain)
	$ElevationMap/TerrainMap.set_cell(0,0,tidx)

