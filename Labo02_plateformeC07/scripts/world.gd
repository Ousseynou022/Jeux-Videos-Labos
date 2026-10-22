extends Node2D

@export var level_left: int = -320
@export var level_right: int = 1920

@onready var player: Player = $Player
@onready var camera: Camera2D = $Player/Camera2D
@onready var info_label: Label = $Interface/InfoLabel


func _ready() -> void:
	camera.limit_left = level_left
	camera.limit_right = level_right


func _process(_delta: float) -> void:
	info_label.text = "ÉTAT : %s\nA/D bouger  ESPACE sauter  J ou clic attaquer" % player.state_machine.current_state_name
