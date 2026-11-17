extends Node2D

@export var music: AudioStream

@onready var player: Player = $Player


func _ready() -> void:
	Audio.play_music(music)
	
	if GameState.has_hub_spawn:
		player.position = GameState.hub_spawn
		player.get_node("Camera2D").reset_smoothing()
		
	
