extends RigidBody3D

var health = 3
var speed = randf_range(2.0, 4.0)

@onready var bat_model: Node3D = %bat_model
@onready var player = get_node("/root/Game/Player")
@onready var timer: Timer = %Timer

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0
	linear_velocity = direction * speed
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + 3*PI/2

func take_damage() -> void:
	if health == 0:
		return
	
	bat_model.hurt()
	health-=1
	
	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -global_position.direction_to(player.global_position)
		var upward_force = Vector3.UP * randf_range(1.0, 3.0)
		apply_central_impulse(direction * 10.0 + upward_force)
		timer.start()
		


func _on_timer_timeout() -> void:
	queue_free()
