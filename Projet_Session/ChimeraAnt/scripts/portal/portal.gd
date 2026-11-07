class_name Portal
extends Area2D

@export var portal_name: String = "Portail 1"
@export var required_level: int = 1
@export_file("*.tscn") var arena_scene: String = ""

@onready var vortex: Sprite2D = $VortexPivot/Vortex
@onready var info_label: Label = $InfoLabel

var player_inside := false


func _ready() -> void:
	info_label.text = "%s\nNiveau requis : %d" % [portal_name, required_level]
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	vortex.rotation += 2.0 * delta   # tourbillon 


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false


func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		if arena_scene == "":
			print("L'arène de ce portail n'existe pas encore.")
			return
		get_tree().change_scene_to_file(arena_scene)
