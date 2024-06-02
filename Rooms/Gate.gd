extends Sprite2D

@onready var animationPlayer = $AnimationPlayer
@onready var playerDetector = $Area2D

@export var exist = true
@export var teleportOffset = Vector2.ZERO

var state = UNLOCKED
var playerDetected = false

enum {
	LOCKED,
	UNLOCKED
}

func _ready():
	Events.connect("curtainsUp", teleport)
	if exist == false:
		visible = false
		playerDetector.monitoring = false

func teleport():
	if get_tree().has_group("Player") and playerDetected:
		get_tree().get_nodes_in_group("Player")[0].global_position = global_position + teleportOffset
		Events.playerMapPosition += teleportOffset.normalized()
		Events.emit_signal("updateMap", Events.playerMapPosition)
		Events.emit_signal("fadeOut")

func _input(_event):
	if Input.is_action_just_pressed("RightClick") and playerDetected and state == UNLOCKED:
		Events.emit_signal("fadeIn")

func _on_area_2d_body_entered(body):
	if body is Player:
		playerDetected = true
		if state == UNLOCKED:
			animationPlayer.play("Open")

func _on_area_2d_body_exited(body):
	if body is Player:
		playerDetected = false
		if state == UNLOCKED:
			animationPlayer.play("Close")

func lock():
	state = LOCKED
	animationPlayer.play("Locked")

func unlock():
	state = UNLOCKED
	animationPlayer.play("RESET")
