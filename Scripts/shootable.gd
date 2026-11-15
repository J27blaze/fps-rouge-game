extends Node
class_name Shootable

@export var parent: Node 
@export var hit_function_name: String
@export var display_damage_numb: bool = true
var damage_numb_instacer: DamageNumbInstancer

func _ready():
	var load: PackedScene = preload("res://UI/DamageNumb/damage_numb_instancer.tscn")
	damage_numb_instacer = load.instantiate()
	add_child(damage_numb_instacer)
	
#add damage type LATER
func on_hit(damage: float, hit_position: Vector3):
	var callable = Callable(parent, hit_function_name)
	
	if callable.is_valid():
		callable.call(damage, hit_position)
		if damage_numb_instacer: damage_numb_instacer.display_numb(damage, hit_position)
		return
	else:
		print(str(parent.name) + " has invalid shootable call!")
