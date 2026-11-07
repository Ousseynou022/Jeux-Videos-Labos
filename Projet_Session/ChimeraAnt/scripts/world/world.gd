extends Node2D

@onready var player: Player = $Player


func _ready() -> void:
	# Au retour d'une arène, on réapparaît devant le portail utilisé
	if GameState.has_hub_spawn:
		player.position = GameState.hub_spawn
		player.get_node("Camera2D").reset_smoothing()
		
	
