class_name MainMenu

extends Control

@onready var start_button: Button = %StartButton
@onready var instructions_button: Button = %InstructionsButton
@onready var options_button: Button = %OptionsButton
@onready var scores_button: Button = %ScoresButton
@onready var quit_button: Button = %QuitButton

@onready var options_menu: OptionsMenu = %OptionsMenu
@onready var buttons_box: VBoxContainer = %ButtonsBox   # mets ButtonsBox en nom unique

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start_button.pressed.connect(_on_start_button_pressed)
	#instructions_button.pressed.connect(_on_instructions_button_pressed)
	#options_button.pressed.connect(_on_options_button_pressed)
	#scores_button.pressed.connect(_on_scores_button_pressed)
	#quit_button.pressed.connect(_on_quit_button_pressed)
	options_menu.closed.connect(_on_options_closed)
	
	
	start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")


func _on_instructions_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	buttons_box.visible = false
	options_menu.open()

func _on_options_closed() -> void:
	buttons_box.visible = true
	options_button.grab_focus()


func _on_scores_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
