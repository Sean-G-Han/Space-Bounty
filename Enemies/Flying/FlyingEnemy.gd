extends Enemy

var playerPath
var speedMultiplier = 1
@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var background = $Background
@onready var hitBox = $Hitbox

func _ready():
	hitBox.Damage = stats.Attack
	if get_tree().has_group("Player"):
		playerPath = get_tree().get_nodes_in_group("Player")[0]
		createPath()

func _physics_process(delta):
	match state:
		INACTIVE:
			animationPlayer.play("RESET")
		MOVE:
			move(delta)
		DIE:
			die()


func createPath():
	nav.target_position = playerPath.global_position

func _on_nav_timer_timeout():
	createPath()

func changeMultiplier(newMultiplier):
	speedMultiplier = newMultiplier

func move(delta):
	sprite.look_at(nav.get_next_path_position())
	sprite.rotation_degrees += 90
	background.rotation_degrees = sprite.rotation_degrees
	if (global_position - playerPath.global_position).length() > 3:
		var nextPath = nav.get_next_path_position()
		var direction = to_local(nextPath).normalized()
		velocity.x = move_toward(velocity.x, direction.x * stats.Speed * speedMultiplier, stats.Acceleration * 60 * delta)
		velocity.y = move_toward(velocity.y, direction.y * stats.Speed * speedMultiplier, stats.Acceleration * 60 * delta)
		move_and_slide()

func activate():
	state = MOVE
	animationPlayer.play("Hover")
