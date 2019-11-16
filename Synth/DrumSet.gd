extends Node

const kick = 36
const cowbell = 37
const hihat = 44
const snare = 45

const MIDI_CHANNEL = 3

func _on_MidiController_note_on(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return

	if pitch == kick:
		$Kick.play()
	if pitch == cowbell:
		$Cowbell.play()
	if pitch == hihat:
		$Hihat.play()
	if pitch == snare:
		$Snare.play()
