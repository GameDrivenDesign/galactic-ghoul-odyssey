extends Node

export var voiceCount = 4

var voices = {}
var Voice = load("res://Synth/AttackVoice.tscn")

func note_on(pitch, velocity, channel):
	if channel != 0:
		return
	play(pitch)

func note_off(pitch, velocity, channel):
	if channel != 0:
		return
	stop(pitch)

# TODO: this is very bad
func play(pitch):
	if !voices.has(pitch):
		voices[pitch] = Voice.instance()
		add_child(voices[pitch])
	voices[pitch].play(pitch)

func stop(pitch):
	voices[pitch].stop()
