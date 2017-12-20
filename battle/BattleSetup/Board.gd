extends VBoxContainer


const MAP_PATH = "res://data/boards"

onready var MapList = $Map/MapList
onready var PreviewMap = $Map/Preview/PreviewMap

var selected_board

func draw_preview_map( map ):
	PreviewMap.clear()
	for cell in map.data:
		var idx = cell.elevation + 5
		var terrain = cell.terrain
		if !terrain.empty():
			if terrain[0] == "water":
				idx = 14
			if terrain[0] == "rough":
				idx = 13
			if terrain[0] == "woods":
				if terrain[1] == 1:
					idx = 11
				elif terrain[1] == 2:
					idx = 12
		PreviewMap.set_cell( cell.cell.x, cell.cell.y, idx )




func setup_boards_tree():
	MapList.set_hide_root(true)


func draw_boards_tree():
	MapList.clear()
	var root = MapList.create_item()
	for board in GameFiles.boards:
		var item = MapList.create_item(root)
		item.set_text(0, board)
	


func _ready():
	setup_boards_tree()
	draw_boards_tree()

func _on_MapList_item_selected():
	self.selected_board = MapList.get_selected().get_text(0)
	draw_preview_map( GameFiles.boards[self.selected_board] )
