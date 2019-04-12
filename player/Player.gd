extends KinematicBody2D

onready var sprite : AnimatedSprite = $Sprite
onready var bot : Node2D = $Bot

export var move_speed := 75
export var jump_force := 155
export var gravity := 400
export var slope_slide_threshold := 50.0

var velocity := Vector2()
var last_direction := 1


func _ready() -> void:
	bot.initialize(self)

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = direction_x * move_speed
	last_direction = direction_x if direction_x != 0 else last_direction

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP, slope_slide_threshold)


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("move_left"):
		sprite.flip_h = false
		sprite.play("run")
	elif event.is_action_pressed("move_right"):
		sprite.flip_h = true
		sprite.play("run")
	elif event.is_action_released("move_left") or event.is_action_released("move_right"):
		sprite.play("idle")
	elif event.is_action_pressed("ui_page_down") and is_on_floor():
		var sentry = load("res://buildings/static-sentry/StaticSentry.tscn").instance()
		get_parent().add_child(sentry)
		sentry.global_position = global_position + Vector2(0, 1)
		bot.queue_building(sentry)
