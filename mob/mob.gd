extends RigidBody3D

@onready var bat_model: Node3D = %bat_model

func take_damage() -> void:
	bat_model.hurt()
