extends Node

const kick = 36
const cowbell = 37
const hihat = 44
const snare = 45

const MIDI_CHANNEL = 3

var total_energy = 0.0
const MAX_ENERGY = 20

const ENERGY_PER_SECOND = 20.0

const SCALE = 2.0

var player
var shield

func _ready():
	player = $"/root/Game/Player"
	shield = $"/root/Game/Player/Shield"

func _on_MidiController_note_on(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
		
	if total_energy < SCALE:
		return
	
	total_energy -= SCALE

	if pitch == kick:
		$Kick.play()
		player.add_shake(3)
		player.movement_energy = min(player.movement_energy + SCALE, MAX_ENERGY)
	if pitch == cowbell:
		$Cowbell.play()
		pass
	if pitch == hihat:
		$Hihat.play()
		shield.energy = min(shield.energy + SCALE, MAX_ENERGY)
	if pitch == snare:
		$Snare.play()
		player.cannon_energy = min(player.cannon_energy + SCALE, MAX_ENERGY)

func _process(delta):
	total_energy = clamp(total_energy + ENERGY_PER_SECOND * delta, SCALE, MAX_ENERGY)
	player.get_node("DrumProgress").value = total_energy