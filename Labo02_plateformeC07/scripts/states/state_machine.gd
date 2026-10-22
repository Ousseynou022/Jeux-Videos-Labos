class_name StateMachine
extends Node


signal state_changed(previous_state: String, new_state: String)

@export var initial_state: State

var current_state: State
var current_state_name: String = ""
var states: Dictionary = {}


func init(player: Player) -> void:
	for child in get_children():
		if child is State:
			var state := child as State
			states[String(state.name).to_lower()] = state
			state.player = player
			state.transitioned.connect(_on_state_transitioned)

	assert(initial_state != null, "StateMachine : initial_state n'est pas défini.")
	current_state = initial_state
	current_state_name = String(initial_state.name).to_lower()
	current_state.enter("")


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_state_transitioned(state: State, new_state_name: String) -> void:
	if state != current_state:
		return

	var key := new_state_name.to_lower()
	if not states.has(key):
		push_warning("StateMachine : l'état « %s » n'existe pas." % new_state_name)
		return

	var previous_name := current_state_name
	current_state.exit()
	current_state = states[key]
	current_state_name = key
	current_state.enter(previous_name)
	state_changed.emit(previous_name, current_state_name)
