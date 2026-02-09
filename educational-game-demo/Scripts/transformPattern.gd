extends Node2D

var phase = 1 
var transform_done = false

func _ready() -> void:
	# 1. RESET the controller so it's clean for this level
	ConveyerController.initialise()
	
	# 2. REGISTER the conveyors (THIS IS THE MISSING PART)
	# This tells the controller: "Use these lines for drawing paths"
	ConveyerController.setup($Conveyor)
	ConveyerController.setup($Conveyor2)
	
	# 3. Rest of your setup
	ConveyerController.can_send = false
	ConveyerController.transformed_events = []
	phase = 1
	transform_done = false
	print("Transformation Pattern Level loaded")
