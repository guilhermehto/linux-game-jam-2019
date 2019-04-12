extends Node2D

onready var tween : Tween = $Tween
onready var pivot : Position2D = $Pivot

var initial_position : float


func _ready() -> void:
	initial_position = position.x


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mine"):
		pick()
	if event.is_action_pressed("move_left") and position.x != initial_position:
		position.x = initial_position
		scale.x = 1.0
	elif event.is_action_pressed("move_right") and position.x != -initial_position:
		position.x = -initial_position
		scale.x = -1.0


func pick() -> void:
	tween.interpolate_property(pivot,
		"rotation_degrees",
		20,
		-45,
		0.15,
		Tween.TRANS_QUINT,
		Tween.EASE_IN)
	tween.interpolate_property(pivot,
		"rotation_degrees",
		-45,
		20,
		0.25,
		Tween.TRANS_BOUNCE,
		Tween.EASE_IN,
		0.15)
	tween.start()
