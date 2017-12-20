extends Node2D

const TILE_INDEX_WATER = 0
const TILE_INDEX_LIGHTWOODS = 1
const TILE_INDEX_HEAVYWOODS = 2
const TILE_INDEX_ROUGH = 3

signal cell_hovered( cell )
signal cell_selected( cell )
var hovered_cell = Vector2()

var selected_cell = null

var in_gui = false

##	HEX CELL CLASS
#	map_data is a 2D array of instances of
#	these guys.
class HexCell:
	var cell = Vector2(0,0)
	var hex = HEX.cell_to_hex( Vector2(0,0) ) setget _set_hex,_get_hex
	var cube = HEX.cell_to_cube( Vector2(0,0) ) setget _set_hex,_get_hex
	var coords = "0101" setget _set_coords, _get_coords

	
	var elevation = 0
	var terrain = []

	
	func get_data():
		return {
			"cell": self.cell,
			"elevation":	self.elevation,
			"terrain":		self.terrain,
			}
	
	func set_data( data ):
		for key in data:
			if key in self:
				self.set( key, data[key] )
	

	
	func get_terrain_string():
		if self.terrain.size() < 2:
			return "clear"
		elif self.terrain[0] == "woods":
			if self.terrain[1] == 1:
				return "light woods"
			elif self.terrain[1] == 2:
				return "heavy woods"
		else:
			return terrain[0]
	
	func _init( coords, elevation=0, terrain=[] ):
		# CELL
		if typeof(coords) == TYPE_VECTOR2:
			self.cell = coords
		# (experimental?)
		# HEX
		elif coords is HEX.Hex:
			self.cell = coords.get_cell()
		# CUBE
		elif coords is HEX.Cube:
			self.cell = coords.to_cell()
		##
		
		self.elevation = elevation
		
		self.terrain = terrain


	func _set_hex( what ):
		self.cell = what.get_cell()
	func _get_hex():
		return HEX.cell_to_hex( self.cell )
	
	func _set_cube( what ):
		self.cell = what.to_cell()
	func _get_cube():
		return HEX.cell_to_cube( self.cell )
	
	func _set_coords( what ):
		var x = int( what.left(2) )
		var y = int( what.right(2) )
		self.cell = Vector2(x,y)
	func _get_coords():
		var x = str(self.cell.x+1).pad_zeros(2)
		var y = str(self.cell.y+1).pad_zeros(2)
		return x+y








# 2D Array of HexCell objects
var map_data = [[]]
# Width and height of the map
# Defined along with map_data
var map_size = Vector2()



# Transfer map_data to paint cells on the game board
func paint_map():
	$ElevationMap.clear()
	$TerrainMap.clear()
	
	for x in range( map_size.x ):
		for y in range( map_size.y ):
			var cell = map_data[x][y]
			var ele = cell.elevation + 6
			$ElevationMap.set_cell( x, y, ele )
			if cell.terrain.size() >= 2:
				var tidx = -1
				var type = cell.terrain[0]
				var val = int(cell.terrain[1])
				if type == "water":
					tidx = TILE_INDEX_WATER
				if type == "woods":
					if val == 1:
						tidx = TILE_INDEX_LIGHTWOODS
					elif val == 2:
						tidx = TILE_INDEX_HEAVYWOODS
				if type == "rough":
					tidx = TILE_INDEX_ROUGH
				$TerrainMap.set_cell( x, y, tidx )
	


# Build and paint a map from map data
func build_map_from_data( map ):
	generate_blank_map( map.size )
	for cell in map.data:
		self.map_data[cell.cell.x][cell.cell.y] = HexCell.new( cell.cell, cell.elevation, cell.terrain )
	paint_map()



func generate_blank_map( map_size=Vector2(16,16) ):
	self.map_size = map_size
	var grid = []
	for x in range( map_size.x ):
		var col = []
		for y in range( map_size.y ):
			col.append( HexCell.new( Vector2( x, y ) ) )
		grid.append( col )
	self.map_data = grid



func is_cell_in_bounds( cell ):
	return Rect2( Vector2(), self.map_size ).intersects( Rect2( cell, Vector2(1,1) ) )



# Paint a deployment zone
# Also returns a Rect2 representing this zone
func draw_deployment_zone( zone, depth=2 ):
	var zone_rect = Rect2(0,0,map_size.x,map_size.y)
	
	if zone == "N":
		zone_rect.size = Vector2( map_size.x, depth )
	elif zone == "S":
		zone_rect.size = Vector2( map_size.x, depth )
		zone_rect.position = Vector2( 0, map_size.y - depth )
	elif zone == "W":
		zone_rect.size = Vector2( depth, map_size.y )
	elif zone == "E":
		zone_rect.size = Vector2( depth, map_size.y )
		zone_rect.position = Vector2( map_size.y - depth, 0 )

	$UnitMap.clear()
	for x in range(zone_rect.size.x):
		for y in range(zone_rect.size.y):
			$UnitMap.set_cell( x+zone_rect.position.x, y+zone_rect.position.y, 0)
	return zone_rect




func _ready():
	build_map_from_data( $BoardImport.read_board("res://data/boards/rollinghills1.board") )






# Control mouse cell selection
func _input(event):
	if !in_gui:
		if event is InputEventMouseMotion:
			var c = $ElevationMap.world_to_map( get_local_mouse_position() )
			if is_cell_in_bounds(c):
				if c != self.hovered_cell or !$Hover.visible:
					self.hovered_cell = c
					emit_signal( "cell_hovered", c )
					$Hover.position = $ElevationMap.map_to_world( c ) 
					$Hover.show()
			else:
				$Hover.hide()
		elif event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and !Input.is_action_pressed("set_facing"):
				var c = $ElevationMap.world_to_map( get_local_mouse_position() )
				if !self.selected_cell or (is_cell_in_bounds(c) and c != self.selected_cell.cell):
					self.selected_cell = map_data[c.x][c.y]
					emit_signal("cell_selected", self.selected_cell )
					$Select.position = $ElevationMap.map_to_world( c )
	else:
		$Hover.hide()

