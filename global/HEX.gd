extends Node

#	HEX GRID MATH FUNCTIONS
#
#	for CELL(offset odd-q vertical), AXIAL, and CUBIC coordinates

var CUBE_DIRECTIONS = [
	Cube.new(1, -1,0),Cube.new(1,0,-1),Cube.new(0,1,-1),
	Cube.new(-1, 1,0),Cube.new(-1,0,1),Cube.new(0,-1,1)]



class Hex:
	var q
	var r
	
	func _init(q,r):
		self.q = q
		self.r = r

	func to_cube():
		var x = self.q
		var z = self.r
		var y = -x-z
		return HEX.Cube.new(x,y,z)
	
	func get_cell():
		return self.to_cube().to_cell()

class Cube:
	var x
	var y
	var z
	
	func _init(x,y,z):
		self.x = x
		self.y = y
		self.z = z
	
	func to_hex():
		var q = self.x
		var r = self.z
		return HEX.Hex.new(q,r)
	
	func to_cell():
		var col = self.x
		var row = self.z + ( self.x - (int(self.x)%2) ) / 2
		return Vector2(col,row)



func cell_to_cube(cell):
	var x = cell.x
	var z = cell.y - (cell.x - (int(cell.x)%2) ) / 2
	var y = -x-z
	return HEX.Cube.new(x,y,z)

func cell_to_hex(cell):
	return cell_to_cube(cell).to_hex()

func cube_distance(a, b):
	return (abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)) / 2

func cube_snap(cube):
	var rx = round(cube.x)
	var ry = round(cube.y)
	var rz = round(cube.z)
	
	var x_diff = abs(rx - cube.x)
	var y_diff = abs(ry - cube.y)
	var z_diff = abs(rz - cube.z)
	
	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry-rz
	elif y_diff > z_diff:
		ry = -rx-rz
	else:
		rz = -rx-ry
	return Cube.new(rx, ry, rz)

func cube_lerp(a, b, t):
	
	return Cube.new(
		lerp(a.x, b.x, t),
		lerp(a.y, b.y, t),
		lerp(a.z, b.z, t))

func cube_line(a, b):
	
	var N = cube_distance(a,b)
	var line = []
	for i in range(N+1):
		line.append(cube_snap( cube_lerp( a, b, 1.0/N * i ) ) )
		
	return line


