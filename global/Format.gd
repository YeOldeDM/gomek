extends Node

static func number(n):
	var s = str(n)
	var a = []
	for c in s:
		a.append(c)
	a.invert()
	var x = 0
	var t = a.size() / 3
	if a.size() > 3:
		for i in range(t):
			a.insert(3+(i*3)+x, ",")
			x += 1
	a.invert()
	s = ""
	for c in a:
		s += c
	return s


	
