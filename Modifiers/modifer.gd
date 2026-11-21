extends EventReceiver
class_name Modifer

#FAHH

var weapon: Weapon

var resource: ModiferResource
var mod_behaviour: ModiferBehaviour

var active: bool = false

func _init(mod_resource: ModiferResource = preload("uid://fi2q1kq8kien")) -> void:
	resource = mod_resource
	
	mod_behaviour = resource.mod_behaviour.new()
	mod_behaviour.weapon = weapon
	mod_behaviour.modifer = self
	
	connect_events()
	
func connect_events() -> void:
	for event in resource.event_connectors:
		print(resource.name)
		EventHandler.connect_event(self, event)
	return

func disconnect_events() -> void:
	for event in resource.event_connectors:
		EventHandler.disconnect_event(self, event)
	return

func on_receive_event(event: Event.Type) -> void:
	mod_behaviour.on_receive_event(event)
	return
