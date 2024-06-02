extends TextureProgressBar

@onready var animationPlayer = $AnimationPlayer

enum {
	ACTIVE,
	INACTIVE
}

var state = INACTIVE : set = stateChanged

func update(x):
	value = x
	if state == ACTIVE:
		x = x/100
		modulate = Color((1 - x), x, 0)
	var tempState = INACTIVE if value == 100 else ACTIVE
	if tempState != state:
		state = tempState

func stateChanged(STATE):
	state = STATE
	if STATE == INACTIVE:
		animationPlayer.play("Fade Out")
	else:
		animationPlayer.play("Fade In")
