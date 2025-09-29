extends Node3D

var score = 0
@onready var label: Label = %Label

func _on_spawner_3d_mob_spawned(mob: Variant) -> void:
	mob.died.connect(func () -> void:
		increase_score()
		do_poof(mob.global_position)
	)
	do_poof(mob.global_position)
	
func do_poof(global_position: Vector3):
	const SMOKE_PUFF = preload("res://mob/smoke_puff/smoke_puff.tscn")
	var poof = SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = global_position
	
	
func increase_score():
	score+=1
	label.text = "Score: " + str(score)


func _on_kill_area_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
