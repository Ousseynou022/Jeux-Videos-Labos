extends Node2D

const FOURMI_SOLDAT := preload("res://scenes/enemies/fourmi_soldat.tscn")

# Réglages de chaque arène : nom, fond, hauteur du sol et ennemis
const ARENAS := {
	1: {
		"name": "Forêt mystérieuse",
		"background": preload("res://assets/backgrounds/arenas/arene_foret.png"),
		"floor_y": 810.0,
		"enemy_scene": FOURMI_SOLDAT,
		"enemy_count": 4,
	},
	2: {
		"name": "Désert volcanique",
		"background": preload("res://assets/backgrounds/arenas/arene_volcan.png"),
		"floor_y": 930.0,
		"enemy_scene": null,   # fourmis ailées : carte « Essaim »
		"enemy_count": 0,
	},
	3: {
		"name": "Arène de la lune rouge",
		"background": preload("res://assets/backgrounds/arenas/arene_reine.png"),
		"floor_y": 745.0,
		"enemy_scene": null,   # la Reine : carte « Combat contre la Reine »
		"enemy_count": 0,
	},
}

@onready var background: Sprite2D = $Background
@onready var floor_shape: CollisionShape2D = $Floor/CollisionShape2D
@onready var player: Player = $Player
@onready var exit_portal: Portal = $ExitPortal
@onready var enemies: Node2D = $Enemies
@onready var title_label: Label = %TitleLabel


func _ready() -> void:
	var data: Dictionary = ARENAS.get(GameState.arena_id, ARENAS[1])
	var floor_y: float = data["floor_y"]

	background.texture = data["background"]
	floor_shape.position.y = floor_y
	exit_portal.position = Vector2(180, floor_y)
	player.position = Vector2(450, floor_y)
	title_label.text = data["name"]
	_spawn_enemies(data, floor_y)
	_show_title()


# Place les ennemis de l'arène, répartis sur la droite
func _spawn_enemies(data: Dictionary, floor_y: float) -> void:
	var scene: PackedScene = data["enemy_scene"]
	if scene == null:
		return
	for i in data["enemy_count"]:
		var enemy := scene.instantiate()
		enemy.position = Vector2(900 + i * 280, floor_y)
		enemies.add_child(enemy)


# Le nom de l'arène apparaît puis disparaît en fondu
func _show_title() -> void:
	title_label.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(title_label, "modulate:a", 1.0, 0.6)
	tween.tween_interval(1.5)
	tween.tween_property(title_label, "modulate:a", 0.0, 0.8)
