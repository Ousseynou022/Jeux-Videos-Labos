class_name Slime
extends StaticBody2D

signal hit_received(total_hits: int)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var hits: int = 0
var _tween: Tween


func _ready() -> void:
	sprite.play("idle")


func take_hit(_damage: int, _from_position: Vector2) -> void:
	hits += 1
	hit_received.emit(hits)

	sprite.modulate = Color(1.0, 0.35, 0.35)
	sprite.scale = Vector2(1.4, 0.6)

	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(sprite, "modulate", Color.WHITE, 0.25)
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
