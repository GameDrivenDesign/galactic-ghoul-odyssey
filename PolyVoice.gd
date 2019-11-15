extends Node

export var voiceCount = 4

var voices = {}
var Voice = load("res://Voice.tscn")

func _ready():
	#for i in range(voiceCount):
	#	voices.append(Voice.instance())
	#	add_child(voices[i])
	pass
		
		
# TODO: this is very bad
func play(pitch):
	voices[pitch] = Voice.instance()
	add_child(voices[pitch])
	voices[pitch].play(pitch)
	
func stop(pitch):
	voices[pitch].stop()