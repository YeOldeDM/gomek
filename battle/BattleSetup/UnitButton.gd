extends Button

onready var UnitIcon = $Box/Unit/UnitIcon
onready var UnitName = $Box/Unit/Info/Name
onready var UnitMass = $Box/Unit/Info/Mass

onready var PilotIcon = $Box/Pilot/Box/Portrait
onready var PilotName = $Box/Pilot/Box/Info/Name
onready var PilotSkill = $Box/Pilot/Box/Info/Skills

onready var TeamName = $Box/Team/Info/Name
onready var UnitBV = $Box/BV/Info/BV





func assign( unit ):
	set_meta("unit", unit)
	var data = GameFiles.units[unit.data]
	var team = Forces.teams[unit.team]
	var tex = load("res://assets/graphics/units/meks/%s.png" % unit.data)
	UnitIcon.texture = tex
	if "team" in unit:
		UnitIcon.modulate = team.color
	
	if "Chassis" in data && "Model" in data:
		UnitName.text = "%s %s" % [data.Chassis, data.Model]
	
	if "Mass" in data:
		UnitMass.text = "%s tons" % str(data.Mass)
	
	PilotName.text = unit.pilot.name
	PilotSkill.text = "%s / %s" % [str(unit.pilot.skills.Gunnery), str(unit.pilot.skills.Piloting)]

	TeamName.text = team.name
	
	UnitBV.text = "BV %s" % Format.number(data["Custom BV"])

