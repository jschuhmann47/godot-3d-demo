extends CharacterBody3D

const SENSIBILITY = 0.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * SENSIBILITY
		# get_node("Camera3D")
		# $Camera3D: alias of the upper comment
		# % lets skip path: %gun_model vs $Camera3D/gun_model
		%Camera3D.rotation_degrees.x -= event.relative.y * SENSIBILITY
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -90.0, 90.0)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	
func _physics_process(delta: float) -> void:
	const SPEED = 5.5 # m/s
	var input_direction_2d = Input.get_vector(
		"move_left","move_right","move_forward","move_back"
	)
	var input_direction_3d = Vector3(input_direction_2d.x, 0.0, input_direction_2d.y)
	
	# without this the w would alywas be the same direction regardless of rotation
	var direction = transform.basis * input_direction_3d
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	velocity.y -= 20.0 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# character3d does not need delta
		velocity.y = 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
		
	
	move_and_slide()
	
	if Input.is_action_pressed("shoot") and %Timer.is_stopped():
		shoot_bullet()

func shoot_bullet() -> void:
	# Does not read the file each time, godot optimizes it
	const BULLET_3D = preload("res://player/bullet_3d.tscn")
	var new_bullet = BULLET_3D.instantiate()
	%Marker3D.add_child(new_bullet)
	new_bullet.global_transform = %Marker3D.global_transform
	
	%Timer.start()
