class_name StateMachine
extends Node
## Machine à états finis : garde UN état actif et gère les transitions.

@export var initial_state: State

var current_state: State


func _ready() -> void:
	# Chaque état enfant reçoit une référence vers l'ennemi (la racine de la scène)
	for child in get_children():
		if child is State:
			child.enemy = owner
	current_state = initial_state
	# On attend que l'ennemi soit prêt (ses @onready) avant d'entrer dans le 1er état
	current_state.enter.call_deferred()


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func change_state(state_name: String) -> void:
	var new_state := get_node_or_null(state_name) as State
	if new_state == null:
		push_warning("État introuvable : " + state_name)
		return
	current_state.exit()
	current_state = new_state
	current_state.enter()
