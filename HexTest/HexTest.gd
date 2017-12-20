extends Node2D

var un

func _ready():
	var o = Vector2(8,8)
	un = $Map/UnitMap.add_unit(o)
	call_deferred("arc")


func arc():
	var O = un.get_map_position()
	var P = O + Vector2(0,-20)
	var C = HEX.cube_line( HEX.cell_to_cube(O), HEX.cell_to_cube(P) )
	for cube in C:
		$Map/UnitMap.set_cellv( cube.to_cell(),0 )
		var OC = HEX.cell_to_cube( O )
		var L = HEX.Cube.new( cube.x - OC.x, cube.y - OC.y, cube.z - OC.z )
		var rotR = HEX.Cube.new( -L.z, -L.x, -L.y )
		var rotL = HEX.Cube.new( -L.y, -L.z, -L.x )
		if C.find(cube)%2 == 1:
			print("A")
			rotL.y += 1
			rotL.z -= 1
		$Map/UnitMap.set_cellv( O + rotR.to_cell(), 0 )
		$Map/UnitMap.set_cellv( O + rotL.to_cell(), 0 )
		

