extends Node
class_name StateMachine

@onready var all_states
@export var parent: Node
@export var start_state: String
@export var print_state: bool = false

var states: Dictionary[String, State]
var cur_state: State
var prev_state: State

func init():
	all_states = get_children()
	
	for child in all_states:
		child.init()
		child.parent = parent
		states[str(child.name).to_lower()] = child
	
	prev_state = states["idle"]
	print(states)
	change_state(start_state)

func change_state(new_state: String, transfer_data = null):
	if cur_state:
		cur_state.exit()
		prev_state = cur_state
		#print( current_state.name)
	#else:
	#	push_error(new_state + " does not exist.")
	cur_state = states[new_state]
	cur_state.transfer_data = transfer_data
	if print_state: print(str(self.name) + ": " + str(new_state))
	cur_state.start()

func process_physics(delta: float):
	cur_state.process_physics(delta)
	for state in all_states:
		state.always_process_physics(delta)

func process_frame(delta: float):
	cur_state.process_frame(delta)
