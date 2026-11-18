extends Node

# look at events.gd for all events

var connected_event_receivers: Dictionary[int, Array] = {}
const print_to_console: bool = false

func call_event(event: Event.Type) -> void:
	if print_to_console: print("EventHandler call_event " + str(event))
	if connected_event_receivers.has(event): for receiver in connected_event_receivers[event]:
		receiver.on_receive_event(event)

#add batch connect
func connect_event(receiver: EventReceiver, event: Event.Type) -> void:
	if connected_event_receivers.has(event): 
		var temp: Array = connected_event_receivers[event]
		temp.append(receiver)
		connected_event_receivers[event] = temp
		return
	else:
		connected_event_receivers[event] = [receiver]
		return

func disconnect_event(receiver: EventReceiver, event: Event.Type) -> void:
	if !connected_event_receivers.has(event): 
		print("!! Non existent")
		return
	else:
		var temp: Array = connected_event_receivers[event]
		temp.erase(receiver)
		connected_event_receivers[event] = temp
		return
