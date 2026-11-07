extends CanvasLayer

@onready var pause_panel: Control = %PausePanel
@onready var options_menu: OptionsMenu = %OptionsMenu
@onready var resume_button: Button = %ResumeButton
@onready var restart_button: Button = %RestartButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	visible = false
	options_menu.visible = false

	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(_on_restart_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	options_menu.closed.connect(_on_options_closed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if options_menu.visible:
			options_menu.close()  # Échap ferme d'abord les options
		elif visible:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()


func pause() -> void:
	visible = true
	pause_panel.visible = true
	get_tree().paused = true
	resume_button.grab_focus()


func resume() -> void:
	visible = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	get_tree().paused = false  # sinon la scène rechargée reste figée
	get_tree().reload_current_scene()


func _on_options_pressed() -> void:
	pause_panel.visible = false
	options_menu.open()


func _on_options_closed() -> void:
	pause_panel.visible = true
	options_button.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
