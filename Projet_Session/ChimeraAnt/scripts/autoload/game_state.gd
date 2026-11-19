extends Node

signal xp_changed                
signal leveled_up(new_level: int) 

const HUB_SCENE := "res://scenes/world/world.tscn"
const ARENA_SCENE := "res://scenes/arena/arena.tscn"
const MAIN_MENU_SCENE := "res://scenes/menus/main_menu.tscn"
const MAX_LIVES := 3
const BASE_MAX_HEALTH := 100
const HEALTH_PER_LEVEL := 10      
const ARENA_CLEAR_XP := 50        

var arena_id := 0            
var hub_spawn := Vector2.ZERO 
var has_hub_spawn := false

var player_max_health := BASE_MAX_HEALTH
var player_health := BASE_MAX_HEALTH
var lives := MAX_LIVES

var level := 1
var xp := 0


func reset() -> void:
	arena_id = 0
	has_hub_spawn = false
	player_max_health = BASE_MAX_HEALTH
	player_health = BASE_MAX_HEALTH
	lives = MAX_LIVES
	level = 1
	xp = 0


func xp_needed() -> int:
	return 100 * level


func add_xp(amount: int) -> void:
	xp += amount
	while xp >= xp_needed():
		xp -= xp_needed()
		level += 1
		player_max_health += HEALTH_PER_LEVEL
		player_health = player_max_health  
		leveled_up.emit(level)
	xp_changed.emit()


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
