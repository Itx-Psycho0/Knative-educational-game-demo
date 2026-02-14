extends Node2D

var selected
var events = []
var destination = []
var conveyer = []
var conveyerInd = 0
var dragging
var sendingEnd = false
var can_send = false
var started = false

# Transformer support
var transformer_target = null
var transformed_events = []
var awaiting_transform = false

func initialise():
	self.selected = null
	self.events = []
	self.destination = []
	self.conveyer = []
	self.conveyerInd = 0
	self.dragging = false
	self.sendingEnd = false
	self.can_send = false
	self.started = false
	self.transformer_target = null
	self.transformed_events = []
	self.awaiting_transform = false

func setup(conveyer) -> void:
	self.conveyer.append(conveyer)
	self.can_send = false
	self.sendingEnd = false
	self.events = []
	self.started = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if self.can_send and not self.started and self.destination != null:
		self.send_event()

func create_conveyor():
	# FIX: The .tscn Line2D nodes only have 1 point each.
	# set_point_position(1, ...) silently fails because index 1 doesn't exist.
	# Solution: clear all points and add 2 fresh ones. This ALWAYS works.
	var line = conveyer[conveyerInd]
	line.clear_points()
	line.add_point(selected.get_position())
	line.add_point(destination[conveyerInd])
	
	AudioManager.play_construction()
	conveyerInd += 1

func send_event():
	print("sending events!")
	self.started = true
	if conveyerInd != 0:
		for n in events.size():
			events[n].sending = true
			var tween = get_tree().create_tween()
			tween.tween_property(events[n], "position", destination[n % conveyerInd], 2).set_trans(tween.TRANS_LINEAR)
			if n % conveyerInd == conveyerInd - 1:
				await tween.finished
	
	# If waiting for transformation, DON'T end the level yet.
	# The transformer will handle the event and call reset_for_phase2().
	if awaiting_transform:
		print("Event delivered to transformer. Waiting for transformation...")
		return
	
	# FIX: The START button calls Level.initialise() which resets transformCompleted.
	# Restore it here if we actually did transform an event.
	if transformed_events.size() > 0:
		Level.transformCompleted = true
	
	Level.next_level()

# Called by transformer.gd after transformation completes.
# Resets routing state so the player can route the transformed event to the sink.
func reset_for_phase2():
	print("Phase 2: Now click the transformed event, then click the Sink")
	self.selected = null
	self.started = false
	self.can_send = false
	self.awaiting_transform = false
	# Clear phase 1 destinations
	self.destination = []
	# Slice off used conveyors, keep remaining for phase 2
	# e.g. [Conveyor, Conveyor2] with conveyerInd=1 becomes [Conveyor2]
	self.conveyer = self.conveyer.slice(conveyerInd)
	self.conveyerInd = 0
