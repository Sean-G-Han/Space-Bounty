extends Enemy

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var sprite = $Sprite2D
@onready var hitBox = $Hitbox
@onready var wallDetector = $Detectors/WallDetector
@onready var ledgeDetector = $Detectors/LedgeDetector
@onready var detectors = $Detectors
@onready var items = $Items

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.LEFT

func _ready():
	hitBox.Damage = stats.Attack

func _physics_process(delta):
	match state:
		INACTIVE:
			pass
		MOVE:
			move(delta)
		DIE:
			die()

func move(delta):
	if is_on_floor():
		animationPlayer.play("Walk")
		velocity.x = move_toward(velocity.x, direction.x * stats.Speed, stats.Acceleration * delta * 60)
		if wallDetector.is_colliding() or not ledgeDetector.is_colliding():
			direction.x = -direction.x
			detectors.scale.x = -detectors.scale.x
			sprite.scale.x = -sprite.scale.x
	else:
		animationPlayer.play("Fall")
		pass
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, -stats.FallSpeed, stats.FallSpeed)
	move_and_slide()

func die():
	changeHurtbox(false)
	if items.get_child_count() > 0:
		for item in items.get_children():
			item.changeHurtbox(false)
	animationPlayer.play("RESET")
	hurtPlayer.play("Die")

func activate():
	state = MOVE
	if items.get_child_count() > 0:
		for item in items.get_children():
			item.activate()
