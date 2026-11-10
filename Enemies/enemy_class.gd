extends CharacterBody3D
class_name Enemy

@export var health : float = 100

func on_hit():
	health -= 10

func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
