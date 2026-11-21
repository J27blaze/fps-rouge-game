extends Node
class_name ModiferBehaviour

var weapon: Weapon
var modifer: Modifer

#weapon specific stuff
var damage_flat_increase: float = 0.0
var damage_x_increase: float = 1.0

func on_receive_event(event: Event.Type) -> void:
	pass
