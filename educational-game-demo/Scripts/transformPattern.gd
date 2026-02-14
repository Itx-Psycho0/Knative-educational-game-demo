extends Node2D

var phase = 1
var transform_done = false

func _ready() -> void:
	# Don't call ConveyerController.initialise() - children already registered
	ConveyerController.transformed_events = []
	ConveyerController.awaiting_transform = false
	
	phase = 1
	transform_done = false
	
	print("=== TRANSFORM LEVEL DIAGNOSTIC ===")
	print("Transformation Pattern Level Loaded")
	
	# CHECK 1: Are conveyors registered?
	print("CHECK 1 - Conveyors registered: ", ConveyerController.conveyer.size())
	for i in ConveyerController.conveyer.size():
		print("  Conveyor ", i, ": ", ConveyerController.conveyer[i], " points=", ConveyerController.conveyer[i].get_point_count())
	
	# CHECK 2: Are events registered?
	print("CHECK 2 - Events registered: ", ConveyerController.events.size())
	for i in ConveyerController.events.size():
		print("  Event ", i, ": ", ConveyerController.events[i], " pos=", ConveyerController.events[i].position)
	
	# CHECK 3: Does BoxEvent exist and have an Area2D child?
	var box = $BoxEvent
	print("CHECK 3 - BoxEvent node: ", box)
	print("  BoxEvent position: ", box.position)
	print("  BoxEvent scale: ", box.scale)
	print("  BoxEvent children: ", box.get_child_count())
	for child in box.get_children():
		print("    Child: ", child.name, " type=", child.get_class())
		if child is Area2D:
			print("    Area2D input_pickable: ", child.input_pickable)
			print("    Area2D monitorable: ", child.monitorable)
			print("    Area2D monitoring: ", child.monitoring)
			for subchild in child.get_children():
				print("      Subchild: ", subchild.name, " type=", subchild.get_class())
				if subchild is CollisionShape2D:
					print("      Shape: ", subchild.shape)
					print("      Shape disabled: ", subchild.disabled)
	
	# CHECK 4: Transformer setup
	var transformer = $Transformer
	print("CHECK 4 - Transformer: ", transformer)
	print("  Transformer position: ", transformer.position)
	var tarea = $Transformer/Area2D
	print("  Transformer Area2D input_pickable: ", tarea.input_pickable)
	
	# CHECK 5: Sink setup
	var sink_node = $Sink
	print("CHECK 5 - Sink: ", sink_node)
	print("  Sink position: ", sink_node.position)
	print("  Sink expectedType: ", sink_node.expectedType)
	
	# CHECK 6: ConveyerController state
	print("CHECK 6 - Controller state:")
	print("  selected: ", ConveyerController.selected)
	print("  can_send: ", ConveyerController.can_send)
	print("  conveyerInd: ", ConveyerController.conveyerInd)
	print("  started: ", ConveyerController.started)
	
	print("=== END DIAGNOSTIC ===")
	print("Phase 1: Click the event box FIRST, then click the Transformer")
