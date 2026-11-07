class_name Portal
extends Area2D

@export var portal_name: String = "Portail 1"
@export var required_level: int = 1
@export var arena_id: int = 1  # 1, 2 ou 3 = arène ; 0 = sortie vers le camp

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
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	vortex.rotation += 2.0 * delta   # le tourbillon tourne


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		prompt_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		prompt_label.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		if arena_id == 0:
			GameState.return_to_hub()
		else:
			# on reviendra juste à droite de ce portail
			GameState.enter_arena(arena_id, global_position + Vector2(180, 0))
