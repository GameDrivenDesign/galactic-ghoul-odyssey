extends Node2D

var pressed_keys = []
var active_shields = []

const SHIELD_DURATION = 2

const MIDI_CHANNEL = 0

var energy = 0.0

func can_harm(projectile):
	for shield in active_shields:
		if shield.color == projectile.projectile_color:
			return false
	return true

func _ready():
	get_node("../..//MidiController").connect("note_on", self, "note_on")
	get_node("../..//MidiController").connect("note_off", self, "note_off")

func note_on(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
		
	if energy < 1.0:
		pass
		#return
	energy -= 1.0

	pressed_keys.append(pitch)
	if len(pressed_keys) == 3:
		analyze_chords(pressed_keys)

func note_off(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
	pressed_keys.erase(pitch)

const ADD_BRIGHTNESS = 0.1

func _draw():
	var i = active_shields.size() - 1
	for shield in active_shields:
		draw_circle(Vector2(0, 0), 170 + i * 20, Color(0.18, 0.19, 0.211))
		draw_circle(Vector2(0, 0), 170 + i * 20,
			Color(shield.color.r + ADD_BRIGHTNESS, shield.color.g + ADD_BRIGHTNESS, shield.color.b + ADD_BRIGHTNESS, shield.time))
		i = i - 1

func _process(delta):
	for shield in [] + active_shields:
		shield['time'] -= delta
		if shield['time'] <= 0:
			active_shields.erase(shield)
	update()

func get_shield_of_color(color):
	for shield in active_shields:
		if shield['color'] == color:
			shield['time'] = SHIELD_DURATION
			return
	var ring = {'color': color, 'time': SHIELD_DURATION}
	active_shields.insert(0, ring)
	print(active_shields)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func analyze_chords(notes):
	notes.sort()
#	if (notes[2] - notes[1] > 4):
#		notes[2] -= 12
#	if (notes[1] - notes[0] > 4):
#		notes[0] += 12
#   print("Notes: " + str(notes[2] - notes[1]) + " " + str(notes[1] - notes[0]))
	if notes[2] - notes[1] == 3:
		if notes[1] - notes[0] == 4:
			get_shield_of_color(Color(0, 1, 0))
			print("Dur")
	if notes[2] - notes[1] == 4:
		if notes[1] - notes[0] == 3:
			get_shield_of_color(Color(1, 0, 0))
			print("Moll")
