extends Node
class_name Shootable

@export var parent: Node 
@export var hit_function_name: String

func on_hit():
	var callable = Callable(parent, hit_function_name)
	
	if callable.is_valid():
		callable.call()
		return
	else:
		print(str(parent.name) + " has invalid shootable call!")
