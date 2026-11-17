extends Node3D

var dir: Vector3 = Vector3.FORWARD
var speed: float = 10.0

func _physics_process(delta: float) -> void:
	position += dir * speed * delta
