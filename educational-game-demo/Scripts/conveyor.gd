extends Line2D

func _ready() -> void:
	print("conveyor ready")
	ConveyerController.setup(self)
