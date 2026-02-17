extends Control

# In MainMenu.gd _ready():
func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
	# Add sounds

func _on_start_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()
