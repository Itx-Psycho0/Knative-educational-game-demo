extends Area2D

# What color this transformer outputs
@export var output_color: String = "Pink"
# The texture to swap TO after transformation
@export var output_box_texture: Texture2D
# Whether an event has been transformed already
var has_transformed = false

func _ready() -> void:
	pass

func _on_mouse_entered() -> void:
	$hoverlabel.visible = true

func _on_mouse_exited() -> void:
	$hoverlabel.visible = false

# When player clicks the transformer (to set it as destination)
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		print("Transformer Clicked! Selected is: ", ConveyerController.selected)
		if ConveyerController.selected != null:
			print("Transformer clicked - routing event here")
			AudioManager.play_click_end()
			# Add transformer position as a destination
			ConveyerController.destination.append(get_parent().position)
			ConveyerController.create_conveyor()

# When an event box enters the transformer's area
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Box") and not has_transformed:
		print("Event entered transformer!")
		has_transformed = true
		var event_sprite = area.get_parent()

		# Stop the event at the transformer
		event_sprite.sending = false

		# Play transformation effect
		AudioManager.play_poof()

		# Wait a moment for the visual effect
		await get_tree().create_timer(0.5).timeout

		# TRANSFORM: Change the event's payload color and texture
		if output_box_texture:
			event_sprite.texture = output_box_texture
		event_sprite.boxType = output_color

		# Mark this event as transformed
		ConveyerController.transformed_events.append(event_sprite)
		Level.transformCompleted = true

		print("Event transformed to: ", output_color)

		# Make the event clickable again for the next routing step
		event_sprite.sending = false

		# Flash effect to show transformation
		var tween = get_tree().create_tween()
		tween.tween_property(event_sprite, "modulate", Color(1.5, 1.5, 1.5, 1), 0.2)
		tween.tween_property(event_sprite, "modulate", Color(1, 1, 1, 1), 0.2)
