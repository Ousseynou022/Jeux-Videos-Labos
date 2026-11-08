extends Node

const HUB_SCENE := "res://scenes/world/world.tscn"
const ARENA_SCENE := "res://scenes/arena/arena.tscn"
const MAIN_MENU_SCENE := "res://scenes/menus/main_menu.tscn"
const MAX_LIVES := 3

var arena_id := 0          
var hub_spawn := Vector2.ZERO  # où réapparaître dans le hub au retour
var has_hub_spawn := false

var player_max_health := 100
var player_health := 100
var lives := MAX_LIVES

var level := 1
var xp := 0


func reset() -> void:
	arena_id = 0
	has_hub_spawn = false
	player_health = player_max_health
	lives = MAX_LIVES
	level = 1
	xp = 0

func xp_needed() -> int:
	return 100 * level
	
func enter_arena(id: int, return_position: Vector2) -> void:
	arena_id = id
	hub_spawn = return_position
	has_hub_spawn = true
	get_tree().change_scene_to_file(ARENA_SCENE)


func return_to_hub() -> void:
	get_tree().change_scene_to_file(HUB_SCENE)


func player_defeated() -> void:
	lives -= 1
	if lives <= 0:
		get_tree().change_scene_to_file(MAIN_MENU_SCENE)
	else:
		player_health = int(player_max_health * 0.5)
		return_to_hub()
