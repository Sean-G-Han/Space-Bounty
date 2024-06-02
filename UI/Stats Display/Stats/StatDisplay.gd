extends Panel

@export var icon : Texture = null
@onready var stat = $Label

func _ready():
	$Sprite2D.texture = icon

func update(value):
	stat.text = str(value)
