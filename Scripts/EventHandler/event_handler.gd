extends Node

# look at events.gd for all events

var connected_event_receivers: Dictionary[Event, Array]
const print_to_console: bool = true

func call_event(event: int) -> void:
	if print_to_console: print("EventHandler call_event " + str(event))

func connect_event(receiver: EventReceiver, event: int) -> void:
	if connected_event_receivers.has(event): 
		pass

func disconnect_event(receiver: EventReceiver, event: int) -> void:
	if !connected_event_receivers.has(event): 
		print("!! Non existent")
