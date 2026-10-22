class_name State
extends Node
## Classe de base des états de la machine à état fini du joueur.
##
## Un état sait : quoi faire en entrant (enter), quoi faire à chaque image
## physique (physics_update) et quoi nettoyer en sortant (exit).
## Pour passer à un autre état, il appelle change_to("nom_de_l_etat").

## Émis quand l'état veut céder la place à un autre.
signal transitioned(state: State, new_state_name: String)

## Injecté par StateMachine.init().
var player: Player


func enter(_previous_state: String) -> void:
	pass


func exit() -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func change_to(new_state_name: String) -> void:
	transitioned.emit(self, new_state_name)
