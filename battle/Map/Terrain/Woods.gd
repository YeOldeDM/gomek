extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	randomize()
	make_trees(true)

func make_trees( heavy=false ):
	var n = [ 3+randi()%3, 5+randi()%3 ][int(heavy)]
	
	for i in range(n):
		var tree = $Tree
		if i > 0:
			tree = $Tree.duplicate()
			add_child(tree)
		var passed = false

		print("go")
		var x = int( rand_range( -8, 68 ) )
		var y = int( rand_range( 0, 68 ) )
		tree.position = Vector2( x,y )
		if $Hex.overlaps_area( tree ):
			passed = true
		tree.get_node("Sprite").frame = randi()%8
