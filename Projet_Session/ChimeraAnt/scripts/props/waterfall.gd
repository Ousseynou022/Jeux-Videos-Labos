extends Node2D
## Cascade 

const FRAMES := 8
const FPS := 12.0
const SHEET_HEIGHT := 640.0  

@export var height := 400.0  

@onready var stream: Sprite2D = $Stream
@onready var foam: Sprite2D = $Foam
@onready var sound: AudioStreamPlayer2D = $Sound

var time := 0.0


func _ready() -> void:
	stream.scale.y = height / SHEET_HEIGHT
	foam.position.y = height
	
	var wav := sound.stream as AudioStreamWAV
	if wav:
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
		wav.loop_end = int(wav.get_length() * wav.mix_rate)
	sound.play()


func _process(delta: float) -> void:
	time += delta
	var frame := int(time * FPS) % FRAMES
	stream.frame = frame
	foam.frame = frame
