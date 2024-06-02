extends MarginContainer

@export var Text : Array[String] = []
@onready var timer = $Timer
@onready var label = $MarginContainer2/Label
var lineIndex = 0
var index = 0
var line = ""
var finishedLine = false

func _ready():
	line = Text[lineIndex]
	addWord()

func _input(event):
	if finishedLine and event.is_action_pressed("LeftClick"):
		if lineIndex + 1 < Text.size():
			lineIndex += 1
			index = 0
			line = Text[lineIndex]
			label.text = ""
			addWord()
		else:
			queue_free()

func addWord():
	label.text += line[index]
	if index < line.length() - 1:
		match line[index]:
			'!', '.', ',', '?':
				timer.start(0.2)
			' ':
				timer.start(0.1)
			_:
				timer.start(0.05)
		index += 1
	else:
		finishedLine = true

func _on_timer_timeout():
	addWord()
