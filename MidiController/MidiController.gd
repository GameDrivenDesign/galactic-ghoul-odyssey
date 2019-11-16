extends Node

signal note_off(pitch, velocity, channel)
signal note_on(pitch, velocity, channel)

func _ready():
	OS.open_midi_inputs()

	print(OS.get_connected_midi_inputs())

	for current_midi_input in OS.get_connected_midi_inputs():
		print(current_midi_input)

enum GlobalScope_MidiMessageList {
	MIDI_MESSAGE_NOTE_OFF = 0x8,
	MIDI_MESSAGE_NOTE_ON = 0x9,
	MIDI_MESSAGE_AFTERTOUCH = 0xA,
	MIDI_MESSAGE_CONTROL_CHANGE = 0xB,
	MIDI_MESSAGE_PROGRAM_CHANGE = 0xC,
	MIDI_MESSAGE_CHANNEL_PRESSURE = 0xD,
	MIDI_MESSAGE_PITCH_BEND = 0xE,
};

var notes_held = []

func _process(delta):
	pass
	# print(notes_held)
#	while notes_held.size() > 0:
#		if notes_held[0].timestamp + 1000 < OS.get_ticks_msec():
#			var note = notes_held[0]
#			print("KILL")
#			notes_held.remove(0)
#			emit_signal("note_off", note.pitch, 64, note.channel)
#		else:
#			break

func is_note_active(pitch, channel):
	for note in notes_held:
		if note.pitch == pitch and note.channel == channel:
			return true
	return false

func _unhandled_input(event: InputEvent):
	if event is InputEventMIDI:
		match event.message:
			MIDI_MESSAGE_NOTE_ON:
				notes_held.append({'channel': event.channel, 'pitch': event.pitch, 'timestamp': OS.get_ticks_msec()})
				emit_signal("note_on",  event.pitch, event.velocity, event.channel)

			MIDI_MESSAGE_NOTE_OFF:
				for note in notes_held:
					if note.pitch == event.pitch && note.channel == event.channel:
						notes_held.erase(note)
						break
				emit_signal("note_off", event.pitch, event.velocity, event.channel)
