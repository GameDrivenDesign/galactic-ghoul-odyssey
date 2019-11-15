extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$MidiController.connect("note_on", self, "_on_midicontroller_note_on")
	$MidiController.connect("note_off", self, "_on_midicontroller_note_off")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
