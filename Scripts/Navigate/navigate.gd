extends Node3D
class_name Custom_Navigate

@export var hor_only: bool = true
var target_position: Vector3 = Vector3.ZERO

func get_navigate_dir() -> Vector3:
	var dir: Vector3 = Vector3.ZERO
	
	dir = (target_position - global_position)
	
	if hor_only: dir.y = 0
	dir = dir.normalized()
	
	return dir
