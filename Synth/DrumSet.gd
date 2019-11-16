extends Node

const kick = 36
const cowbell = 37
const hihat = 44
const snare = 45

const MIDI_CHANNEL = 3

var total_energy = 0.0
const MAX_ENERGY = 100

const ENERGY_PER_SECOND = 2.0

var player
var shield

var _timer = null

func _ready():
	player = $"/root/Game/Player"
	shield = $"/root/Game/Player/Shield"
	
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
func _on_Timer_timeout():
	print("drum energy: ", total_energy)
	print("player movement energy: ", player.movement_energy)
	print("player cannon energy: ", player.cannon_energy)
	print("shield energy: ", shield.energy)

func _on_MidiController_note_on(pitch, velocity, channel):
	if channel != MIDI_CHANNEL:
		return
		
	if total_energy < 1.0:
		return
		
	total_energy -= 1.0

	if pitch == kick:
		$Kick.play()
		player.movement_energy += 1.0
	if pitch == cowbell:
		$Cowbell.play()
	if pitch == hihat:
		$Hihat.play()
		shield.energy += 1.0
	if pitch == snare:
		$Snare.play()
		player.cannon_energy += 1.0

func _process(delta):
	total_energy = clamp(total_energy + ENERGY_PER_SECOND * delta, 0.0, MAX_ENERGY)