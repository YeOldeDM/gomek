extends Node



class Unit:
	var data
	var pilot
	var team
	var mods
	
	func _init( data, team=-1, pilot={}, mods={}):
		self.data = data
		self.team = team
		self.pilot = pilot
		self.mods = mods
	
	func get_unit():
		return GameFiles.units[self.data]
	
	func get_mass():
		return self.get_unit().Mass
	
	func get_MP():
		return {
			"walk":	self.get_unit()["Walk MP"],
			"run":	int(self.get_unit()["Walk MP"] * 1.5),
			"jump":	self.get_unit()["Jump MP"] if "Jump MP" in get_unit() else 0
			}
	
	func get_engine_rating():
		return self.get_mass() * self.get_MP().walk
	
	func get_internal_structure():
		return BT.get_internal_structure( self.get_mass() )
	


class Pilot:
	var name
	var skills
	
	func _init( name="Vlad", skills={"Piloting":5, "Gunnery":3} ):
		self.name = name
		self.skills = skills


signal teams_changed()
signal units_changed()

var teams = [] 
var units = [] 


func get_team_BV(team):
	var total = 0
	for unit in get_units_in_team(team):
		total += unit.get_unit()["Custom BV"]
	return total

func get_team_tonnage(team):
	var total = 0
	for unit in get_units_in_team(team):
		total += unit.get_unit().Mass
	return total

func get_team_cost(team):
	var total = 0
	for unit in get_units_in_team(team):
		total += unit.get_unit()["Custom Cost"]
	return total


func get_units_in_team(team):
	var list = []
	for unit in units:
		if unit.team == team:
			list.append(unit)
	return list


func get_units_by_team():
	var list = []
	for team in self.teams:
		list.append([])
	for unit in self.units:
		list[unit.team].append(unit)
	return list

func get_team( name ):
	for team in teams:
		if team.name == name:
			return team

func add_team(name="Team", color=Color(1,1,1), start=0):
	var data =  {
		"name": 	name,
		"color":	color,
		"start":	0,
		}
	teams.append(data) 
	emit_signal("teams_changed")

func remove_team( team ):
	teams.remove( team )
	emit_signal("teams_changed")



func add_unit( unit_data, team, pilot ):
	var data = Unit.new( unit_data, team, pilot )
	self.units.append(data)
	emit_signal("units_changed")
	return data

func remove_unit( unit ):
	var i = units.find(unit)
	if i >= 0:
		units.remove(i)
		emit_signal("units_changed")
		print(units)
	else:
		print("cant find unit!")

func clear_units_in_team(team):
	var list = get_units_by_team(team)
	for unit in list:
		remove_unit(unit)

func clear_all_units():
	self.units = []
	emit_signal("units_changed")

func create_pilot( name, skills ):
	return Pilot.new(name,skills)








