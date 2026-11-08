extends State
## MORT : animation de mort, puis disparition en fondu. État final.

var fading := false


func enter() -> void:
	enemy.velocity.x = 0.0
	enemy.anim.play("death")
	enemy.collision_layer = 0          # on ne peut plus la toucher
	enemy.remove_from_group("enemies")
	enemy.died.emit()


func physics_update(_delta: float) -> void:
	enemy.velocity.x = 0.0
	if not fading and not enemy.anim.is_playing():
		fading = true
		var tween := enemy.create_tween()
		tween.tween_property(enemy, "modulate:a", 0.0, 0.6)
		tween.tween_callback(enemy.queue_free)
