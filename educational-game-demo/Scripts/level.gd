extends Node

# ===== WIN CONDITION ARRAYS =====
# Each index corresponds to a level (0=basicEventFlow, 1=boxClick, etc.)
var sinkBoxMatchNeeded = [false, true, true, false, true, true, true]
var sinkBoxMatchPresent
var sinkUsed
var dlsRequired = [false, false, false, true, false, false, false]
var dlsUsed
var transformRequired = [false, false, false, false, true, true, false]
var transformCompleted
var dataRefRequired = [false, false, false, false, false, false, true]
var dataRefCompleted
var totalbox = [2, 2, 3]
var nextLevel
var levels = [
	"basicEventFlow",    # Level 1: Basic Event Flow
	"boxClick",          # Level 2: Using Filter
	"multiSink",         # Level 3: Multi-Sink
	"dlqPattern",        # Level 4: DLQ Pattern
	"transformPattern",  # Level 5: Transformation Pattern  ← NEW
	"sequencePattern",   # Level 6: Sequence Pattern        ← NEW
	"dataRefPattern",    # Level 7: Data Reference Pattern   ← NEW
]
var levelind = 0

func initialise():
	sinkBoxMatchPresent = true
	sinkUsed = false
	totalbox = 0
	nextLevel = false
	dlsUsed = false
	transformCompleted = false  # NEW
	dataRefCompleted = false    # NEW

func next_level():
	if sinkUsed:
		# Basic levels: just need sink used
		if not sinkBoxMatchNeeded[levelind] and not dlsRequired[levelind] and not transformRequired[levelind] and not dataRefRequired[levelind]:
			print("Basic level passed")
			nextLevel = true
		# Filter levels: need correct box-sink matching
		elif sinkBoxMatchNeeded[levelind] and sinkBoxMatchPresent and not transformRequired[levelind]:
			print("Filter level passed - correct match")
			nextLevel = true
		# DLQ levels: need DLS to be used
		elif dlsRequired[levelind] and dlsUsed:
			print("DLQ level passed")
			nextLevel = true
		# Transform levels: need transform + correct sink match
		elif transformRequired[levelind] and transformCompleted and sinkBoxMatchPresent:
			print("Transform level passed")
			nextLevel = true
		# DataRef levels: need dataref completion
		elif dataRefRequired[levelind] and dataRefCompleted:
			print("DataRef level passed")
			nextLevel = true

	var message_display = preload("res://Scenes/message_display.tscn").instantiate()
	add_child(message_display)
	message_display.z_index = 999

	if nextLevel:
		print("success")
		AudioManager.play_level_clear()
		message_display.show_message("Success")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
		levelind += 1
		if levelind != levels.size():
			ConveyerController.initialise()
			var next_level_path = "res://Scenes/" + levels[levelind] + ".tscn"
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("End of Levels.")
			get_tree().change_scene_to_file("res://Scenes/end_of_all_levels.tscn")
	else:
		print("Failed. Try Again")
		AudioManager.play_level_fail()
		message_display.show_message("Failed. Try Again")
		await message_display.show_message_for_duration(2.0)
		message_display.visible = false
