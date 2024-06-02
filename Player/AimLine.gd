extends Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_point(Vector2.ZERO, 0)
	add_point(get_local_mouse_position(), 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_point_position(1, get_local_mouse_position())
