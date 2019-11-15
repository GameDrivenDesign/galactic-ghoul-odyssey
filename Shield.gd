extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var notes = [21,24,28]
	if (notes[2] - notes[1] > 4):
		notes[2] -= 12
	if (notes[1] - notes[0] > 4):
		notes[0] += 12
	if (notes[2] - notes[1] == 3):
		if (notes[1] - notes[0] == 4):
			$Shield.modulate = Color(0,0,2)
	if (notes[2] - notes[1] == 4):
		if (notes[1] - notes[0] == 3):
			 $Shield.modulate = Color(0,0,1)
	pass
