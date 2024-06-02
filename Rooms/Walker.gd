extends Node

class_name Walker

var CurrentPosition = Vector2.ZERO

const Direction = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
var tempDirection = Direction
var StepHistory = [Vector2.ZERO]

func Walk(distance: int):
	while distance > 0:
		var LookAt = Events.random_array(tempDirection, false)
		var NextPosition = CurrentPosition + LookAt
		var PositionExist = false
		if NextPosition.x > 0:
			for positions in StepHistory:
				if positions == NextPosition:
					PositionExist = true
					break
			CurrentPosition = NextPosition
			if PositionExist == false:
				StepHistory.append(NextPosition)
				distance -= 1
	
	return StepHistory


