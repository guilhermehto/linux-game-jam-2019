extends Node2D
class_name Building

signal build_finished

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var particles : CPUParticles2D = $CPUParticles2D

export(float, 1.0, 5.0) var build_time := 5.0

var time_left : float
var building := false setget set_building
var built := false


func _ready() -> void:
	time_left = build_time
	var frame_count := animated_sprite.frames.get_frame_count("build")
	animated_sprite.frames.set_animation_speed("build", frame_count / build_time)


func _process(delta: float) -> void:
	if building:
		time_left -= delta
		if time_left <= 0:
			built = true
			building = false
			particles.emitting = false
			emit_signal("build_finished")


func set_building(value: bool) -> void:
	building = value
	animated_sprite.playing = building
	particles.emitting = building
