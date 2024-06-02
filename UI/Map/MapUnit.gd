extends Node2D

enum {
	Inactive,
	Exist,
	Visited,
	Active
}

var state = Inactive : set = change
var mapPos = Vector2.ZERO

func change(value):
	state = value
	match state:
		Inactive:
			visible = false
		Exist:
			visible = true
			call_deferred("changeColor", Color(0, 0, 0))
		Visited:
			visible = true
			call_deferred("changeColor", Color(0, 0.5, 0))
		Active:
			visible = true
			call_deferred("changeColor", Color(0, 1, 0))

func changeColor(color):
	$Int.modulate = color
