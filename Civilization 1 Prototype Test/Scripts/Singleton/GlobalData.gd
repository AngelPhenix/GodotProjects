extends Node





############ UNITS ############
const units_data = {
	"Settler": {"attack":0, "hp":1, "movement":2, "production": 5},
	"Explorer": {"attack":1, "hp":3, "movement":3, "production": 8},
	"Warrior": {"attack": 3, "hp":5, "movement":2, "production:": 10}
}

var discovered_units = {
	"Settler": true,
	"Explorer": true,
	"Warrior": true,
	"Archer": false
}

func is_unit_unlocked(unit_name: String) -> bool:
	return discovered_units.get(unit_name, false)

func unlock_unit(unit_name: String) -> void:
	if units_data.has(unit_name):
		discovered_units[unit_name] = true





############ BUILDINGS ############
const buildings_data = {
	"Granary": {"production": 20, "desc": "The Granary gives +2 food."},
	"School": {"production": 35, "desc": "The School gives +5 science."}
}

var discovered_buildings = {
	"Granary": false,
	"School": false
}

func is_building_unlocked(building_name: String) -> bool:
	return discovered_buildings.get(building_name, false)

func unlock_building(building_name: String) -> void:
	if buildings_data.has(building_name):
		discovered_buildings[building_name] = true
