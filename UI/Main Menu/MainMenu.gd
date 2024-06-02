extends CanvasLayer


func _on_button_pressed():
	$AnimationPlayer.play("Fade Out")

func startGame():
	get_tree().change_scene_to_file("res://World.tscn")
