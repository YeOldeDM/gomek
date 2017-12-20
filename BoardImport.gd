extends Node

func read_board( path ):
	var file = File.new()
	var opened = file.open( path, File.READ )
	var map = {"data":[]}
	while !file.eof_reached():
		var txt = file.get_line().split(" ")
		if txt[0] == "size":
			map["size"] = Vector2( int(txt[1]), int(txt[2]) )
		if txt[0] == "hex":
			var terrain = Array(txt[3].replace('"', "").split(":"))
			for word in terrain:
				if word.is_valid_integer():
					terrain[terrain.find(word)] = int(word)
			var cell = {
				"cell": Vector2( int(txt[1].left(2))-1, int(txt[1].right(2))-1 ),
				"elevation": int(txt[2]),
				"terrain":	terrain,
				}
			if terrain[0] == "water":
				cell.elevation -= int(terrain[1])
			map.data.append(cell)
	file.close()
	return map


