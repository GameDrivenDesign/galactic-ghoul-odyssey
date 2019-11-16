extends Node

var pressed_keys = []
var circle_scale = 1.0

const MIDI_CHANNEL = 0

var energy = 0.0

func _ready():
	get_node("../..//MidiController").connect("note_on", self, "note_on")
	get_node("../..//MidiController").connect("note_off", self, "note_off")
	
func note_on(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
		
	if energy < 1.0:
		return
	energy -= 1.0

	pressed_keys.append(pitch)
	if len(pressed_keys) == 3:
		analyze_chords(pressed_keys)
		
func note_off(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return

	pressed_keys.erase(pitch)

func add_circle(color, scale):
	var circle = Sprite.new()
	circle.texture = preload("res://assets/circle_white.png")
	circle.scale = Vector2(scale, scale)
	circle.modulate = color
	add_child(circle)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func analyze_chords(notes):
	notes.sort()
#	if (notes[2] - notes[1] > 4):
#		notes[2] -= 12
#	if (notes[1] - notes[0] > 4):
#		notes[0] += 12
#   print("Notes: " + str(notes[2] - notes[1]) + " " + str(notes[1] - notes[0]))
	if (notes[2] - notes[1] == 3):
		if (notes[1] - notes[0] == 4):
			# $Shield.modulate = Color(1,0,0)
			add_circle(Color(1, 0, 0), circle_scale)
			circle_scale *= 1.5
			print("Dur")
	if (notes[2] - notes[1] == 4):
		if (notes[1] - notes[0] == 3):
			 # $Shield.modulate = Color(0,0,1)
			add_circle(Color(0, 0, 1), circle_scale)
			circle_scale *= 1.5
			print("Moll")
	pass
