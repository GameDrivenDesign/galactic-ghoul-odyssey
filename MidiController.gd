extends Node

signal note_off(pitch, velocity)
signal note_on(pitch, velocity)

func _ready():
	OS.open_midi_inputs()

	print(OS.get_connected_midi_inputs())

	for current_midi_input in OS.get_connected_midi_inputs():
		print(current_midi_input)
		#$"Control/VBoxContainer/MidiInputsList".add_item(current_midi_input, null, false)


# via <https://github.com/godotengine/godot/blob/master/core/os/input_event.h>
enum GlobalScope_MidiMessageList {
	MIDI_MESSAGE_NOTE_OFF = 0x8,
	MIDI_MESSAGE_NOTE_ON = 0x9,
	MIDI_MESSAGE_AFTERTOUCH = 0xA,
	MIDI_MESSAGE_CONTROL_CHANGE = 0xB,
	MIDI_MESSAGE_PROGRAM_CHANGE = 0xC,
	MIDI_MESSAGE_CHANNEL_PRESSURE = 0xD,
	MIDI_MESSAGE_PITCH_BEND = 0xE,
};


const MIDI_EVENT_PROPERTIES = ["channel", "message", "pitch", "velocity", "instrument", "pressure", "controller_number", "controller_value"]


func get_midi_message_description(event : InputEventMIDI):

	if GlobalScope_MidiMessageList.values().has(event.message):
		return GlobalScope_MidiMessageList.keys()[event.message - 0x08]
	return event.message

func _unhandled_input(event : InputEvent):

	if (event is InputEventMIDI):
		match event.message:
			MIDI_MESSAGE_NOTE_ON:
				$PolyVoice.play(event.pitch)
				emit_signal("note_on", event.pitch, event.velocity)

			MIDI_MESSAGE_NOTE_OFF:
				$PolyVoice.stop(event.pitch)
				emit_signal("note_off", event.pitch, event.velocity)