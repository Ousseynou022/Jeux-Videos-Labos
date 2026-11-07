extends Node

const HUB_SCENE := "res://scenes/world/world.tscn"
const ARENA_SCENE := "res://scenes/arena/arena.tscn"

var arena_id := 0              # arène choisie : 1, 2 ou 3
var hub_spawn := Vector2.ZERO  # où réapparaître dans le hub au retour
var has_hub_spawn := false


func reset() -> void:
	arena_id = 0
	has_hub_spawn = false


func enter_arena(id: int, return_position: Vector2) -> void:
	arena_id = id
	hub_spawn = return_position
	has_hub_spawn = true
	get_tree().change_scene_to_file(ARENA_SCENE)


func return_to_hub() -> void:
	get_tree().change_scene_to_file(HUB_SCENE)
