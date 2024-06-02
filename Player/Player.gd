extends Entity

class_name  Player

var NumJumps = 1
var FUEL = 2.0

enum {
	WALK,
	JUMPSQUAT,
	AIR
}

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var hurtPlayer = $HurtPlayer
@onready var fuelBar = $FuelBar
@onready var jumpBuffer = $JumpBuffer
@onready var jumpSound = $JumpSound
@onready var jetPackSound = $JetpackSound

var state = MOVE
var subState = AIR
var canJP = false
var boost = 0.0
var fuelUsed = 0.0
var gravMultiplier = 1
var jumpMultiplier = 1
var isHurt = false
var was_on_floor = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Events.playerBaseStats = stats.duplicate()
	Events.call_deferred("emit_signal", "healthUpdate", stats.Health - damageTaken, stats.Health)

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		DIE:
			die()

func move(delta):
	var direction = Input.get_axis("Left", "Right")

	if get_global_mouse_position().x - global_position.x > 0: #Face cursor next time
		sprite.scale.x = 1
	elif get_global_mouse_position().x - global_position.x < 0:
		sprite.scale.x = -1
	
	match subState:
		WALK:
			walk(delta, direction)
		JUMPSQUAT:
			jumpSquat(delta)
		AIR:
			air(delta, direction)
	fuelBar.update((FUEL - fuelUsed) / FUEL * 100)
	move_and_slide()

func walk(delta, direction):
	canJP = false
	fuelUsed -= 2 * delta
	gravMultiplier = 1
	if direction:
		animationPlayer.play("Walk")
		velocity.x = move_toward(velocity.x, direction * stats.Speed, stats.Acceleration * 60 * delta)
	else:
		animationPlayer.play("Idle")
		velocity.x = move_toward(velocity.x, 0, stats.Acceleration * 60 * delta)
	if not is_on_floor() and jumpBuffer.is_stopped():
		jumpBuffer.start(0.1)
	if Input.is_action_pressed("Up"):
		subState = JUMPSQUAT
		animationPlayer.play("Jump Squat")

func jumpSquat(delta):
	fuelUsed -= 2 * delta
	velocity.x = move_toward(velocity.x, 0, stats.Acceleration * 15 * delta)
	velocity.y += (gravity * gravMultiplier + boost) * delta
	velocity.y = clamp(velocity.y, stats.JumpVelocity, stats.FallSpeed)
	if Input.is_action_just_released("Up") or not animationPlayer.is_playing():
		velocity.y = stats.JumpVelocity / jumpMultiplier
		var stream
		if jumpMultiplier < 1:
			stream = "res://Assets/Sound/SFX/Player/Long-Jump.wav"
		elif jumpMultiplier < 1.5:
			stream = "res://Assets/Sound/SFX/Player/Mid-Jump.wav"
		else:
			stream = "res://Assets/Sound/SFX/Player/Jump.wav"
		jumpSound.stream = load(stream)
		jumpSound.playing = true
		subState = AIR

func air(delta, direction):
	animationPlayer.play("Air")
	if direction:
		velocity.x = move_toward(velocity.x, direction * stats.Speed, stats.Acceleration * 40 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, stats.Acceleration * 40 * delta)
	velocity.y += (gravity * gravMultiplier + boost) * delta
	if is_on_floor():
		subState = WALK

	if Input.is_action_just_pressed("Up"):
		canJP = true
	
	if Input.is_action_just_pressed("Down"):
		gravMultiplier = 3

	if Input.is_action_pressed("Up") and canJP and not is_on_floor() and fuelUsed < FUEL:
		animationPlayer.play("JetPack")
		jetPack(true, delta)
	else:
		jetPack(false, delta)

	if boost < 0:
		velocity.y = clamp(velocity.y, stats.JumpVelocity/1.5, stats.FallSpeed/5)
	else:
		velocity.y = clamp(velocity.y, stats.JumpVelocity/0.1, stats.FallSpeed * gravMultiplier)

func takeDamage(damage):
	if not isHurt:
		damageTaken += damage
		isHurt = true
	Events.emit_signal("healthUpdate", stats.Health - damageTaken, stats.Health)
	if damageTaken < stats.Health:
		hurtPlayer.play("Hurt")
	else:
		state = DIE
		visible = false
		spewBlood(Vector2(1.5,1.5), Color.GREEN)
		Events.emit_signal("playerDied")
		get_tree().paused = true

func jetPack(status: bool, delta):
	if status:
		if jetPackSound.playing == false:
			jetPackSound.playing = true
		jetPackSound.volume_db = -15
		gravMultiplier = 1
		fuelUsed += 1 * delta
		fuelUsed = clamp(fuelUsed, 0, FUEL)
		if fuelUsed < FUEL:
			boost = move_toward(boost, -stats.FallSpeed * 2, stats.FallSpeed/4)
		else:
			boost = move_toward(boost, 0, stats.FallSpeed)
	else:
		if jetPackSound.playing:
			jetPackSound.volume_db = move_toward(jetPackSound.volume_db, -80, delta * 120)
		if jetPackSound.volume_db <= -70:
			jetPackSound.playing = false
		boost = move_toward(boost, 0, stats.FallSpeed)

func die():
	pass

func _on_jump_buffer_timeout():
	subState = AIR

func changeMultiplier(value: float):
	jumpMultiplier = value

func _on_hurt_player_animation_finished(_anim_name):
	isHurt = false
