extends Node

export var voiceCount = 4

var voices = {}
var Voice = load("res://Voice.tscn")

func _ready():
	#for i in range(voiceCount):
	#	voices.append(Voice.instance())
	#	add_child(voices[i])
	pass
		
		
func _on_MidiController_note_on(pitch, velocity):
	play(pitch)
	
func _on_MidiController_note_off(pitch, velocity):
	stop(pitch)
		
# TODO: this is very bad
func play(pitch):
	voices[pitch] = Voice.instance()
	add_child(voices[pitch])
	voices[pitch].play(pitch)
	
func stop(pitch):
	voices[pitch].stop()
