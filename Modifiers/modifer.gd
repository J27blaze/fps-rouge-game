extends EventReceiver
class_name Modifer

#FAHH

var resource: ModiferResource = preload("uid://fi2q1kq8kien")
var mod_behaviour: ModiferBehaviour

func _ready() -> void:
	mod_behaviour = resource.mod_behaviour.new()

func connect_events() -> void:
	for event in resource.event_connectors:
		EventHandler.connect_event(self, event)
	return

func disconnect_events() -> void:
	for event in resource.event_connectors:
		EventHandler.disconnect_event(self, event)
	return

func on_receive_event(event: Event.Type):
	mod_behaviour.on_receive_event(event)
	return
