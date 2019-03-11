extends CanvasLayer

func _input(event):
	if event is InputEventKey:
        if event.pressed and Input.is_action_just_pressed("ui_accept"):
            next_phrase()
			
