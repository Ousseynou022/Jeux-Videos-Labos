extends Node2D

# Réglages de chaque arène : nom, image de fond et hauteur du sol
const ARENAS := {
	1: {
		"name": "Forêt mystérieuse",
		"background": preload("res://assets/backgrounds/arenas/arene_foret.png"),
		"floor_y": 810.0,
	},
	2: {
		"name": "Désert volcanique",
		"background": preload("res://assets/backgrounds/arenas/arene_volcan.png"),
		"floor_y": 930.0,
	},
	3: {
		"name": "Arène de la lune rouge",
		"background": preload("res://assets/backgrounds/arenas/arene_reine.png"),
		"floor_y": 745.0,
	},
}

@onready var background: Sprite2D = $Background
@onready var floor_shape: CollisionShape2D = $Floor/CollisionShape2D
@onready var player: Player = $Player
@onready var exit_portal: Portal = $ExitPortal
@onready var title_label: Label = %TitleLabel


func _ready() -> void:
	var data: Dictionary = ARENAS.get(GameState.arena_id, ARENAS[1])
	var floor_y: float = data["floor_y"]

	background.texture = data["background"]
	floor_shape.position.y = floor_y
	exit_portal.position = Vector2(180, floor_y)
	player.position = Vector2(450, floor_y)
	title_label.text = data["name"]
	_show_title()


# Le nom de l'arène apparaît puis disparaît en fondu
func _show_title() -> void:
	title_label.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(title_label, "modulate:a", 1.0, 0.6)
	tween.tween_interval(1.5)
	tween.tween_property(title_label, "modulate:a", 0.0, 0.8)
