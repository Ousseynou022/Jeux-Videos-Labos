class_name State
extends Node
## Classe de base de tous les états (patron État / State).
## Chaque état redéfinit seulement les fonctions dont il a besoin.

var enemy: Enemy  # l'ennemi contrôlé (donné par la StateMachine)


## Appelée quand on ENTRE dans cet état
func enter() -> void:
	pass


## Appelée quand on QUITTE cet état
func exit() -> void:
	pass


## Appelée à chaque image de physique tant que cet état est actif
func physics_update(_delta: float) -> void:
	pass
