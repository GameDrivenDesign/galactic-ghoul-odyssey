extends Node

var attack = 0.05
var current = 0.0
var active = false
var base_volume_db = 0.0
var pitch = 0

func _ready():
	base_volume_db = $Sample.volume_db

func play(pitch):
	var c4 = 72
	var offset = pitch - c4
	var pitch_scale = pow(2, (offset / 12.0))
	if !$Sample.playing:
		$Sample.play()
	$Sample.pitch_scale = pitch_scale
	$Sample.set_volume_db(-80)
	active = true
	self.pitch = pitch

func stop():
	active = false
	if has_node("EndSample") and $Sample.playing:
		$EndSample.play()
	
func _process(delta):
	if active:
		current = clamp(current + delta/attack, 0.0, 1.0)
		#print("I'm playing: " + str(pitch))
	if !active:
		current = clamp(current - delta/attack, 0.0, 1.0)
	
	if current <= 0.1 and $Sample.playing:
		$Sample.stop()
	
	$Sample.set_volume_db(base_volume_db + (-1.0 + current) * 100)