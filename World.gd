extends Node2D

var steps = []
var D
var DL
var DLR
var DLRU
var DLU
var DR
var DRU
var DU
var L
var LR
var LRU
var LU
var R
var RU
var U

func _ready():
	Events.reset()
	get_tree().paused = false
	Bgm.playing = true
	var walker = Walker.new()
	steps = walker.Walk(15)
	Events.emit_signal("createMap", steps)
	loadRooms()
	call_deferred("spawnRoom")

func spawnRoom():
	for step in steps:
		if step != Vector2.ZERO:
			var d = look(Vector2.DOWN, step)
			var l = look(Vector2.LEFT, step)
			var r = look(Vector2.RIGHT, step)
			var u = look(Vector2.UP, step)
			if d and l and r and u:
				initializeRoom(DLRU, step)
			elif d and l and r:
				initializeRoom(DLR, step)
			elif d and l and u:
				initializeRoom(DLU, step)
			elif d and r and u:
				initializeRoom(DRU, step)
			elif d and l:
				initializeRoom(DL, step)
			elif d and r:
				initializeRoom(DR, step)
			elif d and u:
				initializeRoom(DU, step)
			elif d:
				initializeRoom(D, step)
			elif l and r and u:
				initializeRoom(LRU, step)
			elif l and r:
				initializeRoom(LR, step)
			elif l and u:
				initializeRoom(LU, step)
			elif l:
				initializeRoom(L, step)
			elif r and u:
				initializeRoom(RU, step)
			elif r:
				initializeRoom(R, step)
			elif u:
				initializeRoom(U, step)

func initializeRoom(roomType, Position):
	var instance = Events.random_array(roomType, true).instantiate()
	instance.global_position = Position * Vector2(752, 496)
	call_deferred("add_child", instance)

func look(Direction, Position):
	for step in steps:
		if Direction + Position == step:
			return true
	return false

func loadRooms():
	D = Events.load_files_in_directory("res://Rooms/D/")
	DL = Events.load_files_in_directory("res://Rooms/DL/")
	DLR = Events.load_files_in_directory("res://Rooms/DLR/")
	DLRU = Events.load_files_in_directory("res://Rooms/DLRU/")
	DLU = Events.load_files_in_directory("res://Rooms/DLU/")
	DR = Events.load_files_in_directory("res://Rooms/DR/")
	DRU = Events.load_files_in_directory("res://Rooms/DRU/")
	DU = Events.load_files_in_directory("res://Rooms/DU/")
	L = Events.load_files_in_directory("res://Rooms/L/")
	LR = Events.load_files_in_directory("res://Rooms/LR/")
	LRU = Events.load_files_in_directory("res://Rooms/LRU/")
	LU = Events.load_files_in_directory("res://Rooms/LU/")
	R = Events.load_files_in_directory("res://Rooms/R/")
	RU = Events.load_files_in_directory("res://Rooms/RU/")
	U = Events.load_files_in_directory("res://Rooms/U/")
