class_name Portal
extends Area2D

@export var portal_name: String = "Portail 1"
@export var required_level: int = 1
@export var arena_id: int = 1 

@onready var vortex: Sprite2D = $VortexPivot/Vortex
@onready var info_label: Label = $InfoLabel
@onready var prompt_label: Label = $PromptLabel

var player_inside := false


func _ready() -> void:
	if arena_id == 0:
		info_label.text = portal_name
	else:
		info_label.text = "%s\nNiveau requis : %d" % [portal_name, required_level]
	prompt_label.visible = false
	
	if is_locked():
		vortex.modulate = Color(0.35, 0.35, 0.45) 
		
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	vortex.rotation += 2.0 * delta  

func is_locked() -> bool:
	return arena_id != 0 and GameState.level < required_level


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		if is_locked():
			prompt_label.text = "Verrouillé : niveau %d requis" % required_level
			prompt_label.modulate = Color(1.0, 0.45, 0.45)
		else:
			prompt_label.text = "[E] Entrer"
			prompt_label.modulate = Color.WHITE
		prompt_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		prompt_label.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		if is_locked():
			Audio.play_sfx("ui_move", 0.0)
			var tween := create_tween()
			for offset in [8.0, -8.0, 5.0, 0.0]:
				tween.tween_property(prompt_label, "position:x", -150.0 + offset, 0.05)
			return
		Audio.play_sfx("portal", 0.0)
		if arena_id == 0:
			GameState.return_to_hub()
		else:
			GameState.enter_arena(arena_id, global_position + Vector2(180, -60))
