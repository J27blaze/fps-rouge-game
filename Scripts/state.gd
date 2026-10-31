extends Node
class_name State

@onready var state_machine = get_parent()
var parent #any data type
var transfer_data #any data type
var timer: float = 0.0

# ready state
func init() -> void:
	pass

# enter state
func start() -> void:
	pass
func timer_reset() -> void:
	timer = 0

# exit state
func exit() -> void:
	pass

func change_state(state: String, transfer_data = null) -> void:
	state_machine.change_state(state, transfer_data)
	
# process_input
func process_input(event: InputEvent):
	#write on input event code here
	return null

# process_frame
func process_frame(delta: float):
	return null
func timer_tick(delta:float):
	timer += delta

# process_physics
func process_physics(delta: float):
	#Write state changing code here
	return null

# process physics every frame regaurdless of state. Good for updating global player variables
func always_process_physics(delta: float):
	#write code that needs to change all the time.
	return null
