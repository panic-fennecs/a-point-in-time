extends VBoxContainer

var focused_button_id

func _ready():
	focused_button_id = $StartButton.get_index()
	
func _process(delta):
	$".".get_child(focused_button_id).grab_focus()

func _input(event):
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		if focused_button_id > 0:
			focused_button_id -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		if focused_button_id < 2:
			focused_button_id += 1

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_CreditsButton_pressed():
	pass # replace with function body

func _on_QuitButton_pressed():
	get_tree().quit()