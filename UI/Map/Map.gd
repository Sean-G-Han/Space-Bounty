extends Node2D

@onready var root = $Root
var zoom = 1.0
var mapUnit = preload("res://UI/Map/MapUnit.tscn")
var offset = 72
var limitL = 0
var limitD = 0
var limitR = 0
var limitU = 0

func _ready():
	Events.connect("createMap", createMap)
	Events.connect("updateMap", updateMap)

func createMap(steps):
	for positions in steps:
		var instance = mapUnit.instantiate()
		instance.global_position = positions * offset + Vector2(-24,-24)
		instance.state = instance.Inactive
		instance.mapPos = positions
		root.call_deferred("add_child", instance)
		call_deferred("updateMap", Vector2.ZERO)

func updateMap(newPos):
	for mapUnits in root.get_children():
		if mapUnits.mapPos == newPos:
			mapUnits.state = mapUnits.Active
		elif mapUnits.state == mapUnits.Active:
			mapUnits.state = mapUnits.Visited
		elif (mapUnits.mapPos - newPos).length() == 1 and mapUnits.state == mapUnits.Inactive:
			mapUnits.state = mapUnits.Exist
		
		if mapUnits.state != mapUnits.Inactive:
			if mapUnits.mapPos.x < limitL: limitL = mapUnits.mapPos.x
			elif mapUnits.mapPos.x > limitR: limitR = mapUnits.mapPos.x
			elif mapUnits.mapPos.y < limitU: limitU = mapUnits.mapPos.y
			elif mapUnits.mapPos.y > limitD: limitD = mapUnits.mapPos.y
	Events.playerMapPosition = newPos
	center()

func center():
	root.position = Vector2((limitR + limitL)/2, (limitD + limitU)/2) * -offset
	
	if ((limitR - limitL) * zoom > 7) or ((limitD - limitU) *  zoom > 5):
		print("Shrink: ", (limitR - limitL), " ", (limitD - limitU) )
		zoom = (zoom * 4) /5
		scale.x = zoom
		scale.y = zoom
