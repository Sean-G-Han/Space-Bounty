extends AudioStreamPlayer

func playSound(file: String, volume: int):
	stream = load(file)
	playing = true
	volume_db = volume
