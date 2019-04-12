extends Node2D


export var desired_distance_to_target := 15.0
export var move_speed := 70.0
export var acceleration := 0.75
export var deceleration := 2

const OFFSET := Vector2(0, -15.0)

var player : Node2D
var velocity := Vector2()
var buildings_queue := []


func _ready() -> void:
	set_as_toplevel(true)


func _process(delta: float) -> void:
	if buildings_queue.size() == 0:
		var player_position := player.global_position + OFFSET
		var direction := (player_position - global_position).normalized()
		if player_position.distance_to(global_position) > desired_distance_to_target:
			velocity = velocity.linear_interpolate(direction * move_speed, acceleration * delta)
			global_position += velocity * delta
		else:
			velocity = velocity.linear_interpolate(Vector2.ZERO, deceleration * delta)
			global_position += velocity * delta
	else:
		var target_position := buildings_queue[0].global_position as Vector2
		var direction := (target_position - global_position).normalized()
		if target_position.distance_to(global_position) > desired_distance_to_target:
			velocity = velocity.linear_interpolate(direction * move_speed, acceleration * delta)
			global_position += velocity * delta
		else:
			if not buildings_queue[0].building:
				buildings_queue[0].building = true
			velocity = velocity.linear_interpolate(Vector2.ZERO, deceleration * delta)
			global_position += velocity * delta


func _on_Building_build_finished() -> void:
	buildings_queue.pop_front()


func queue_building(building: Node2D) -> void:
	building.connect("build_finished", self, "_on_Building_build_finished", [], CONNECT_ONESHOT)
	buildings_queue.append(building)


func initialize(target: Node2D) -> void:
	player = target
