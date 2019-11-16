extends Node

var attack = 0.05
var current = 0.0
var active = false

func play(pitch):
	var c4 = 72
	var offset = pitch - c4
	var pitch_scale = pow(2, (offset / 12.0))
	if !$Sample.playing:
		$Sample.play()
	$Sample.pitch_scale = pitch_scale
	$Sample.set_volume_db(-80)
	active = true
	
func stop():
	active = false
	
func _process(delta):
	if active:
		current = clamp(current + delta/attack, 0.0, 1.0)
	if !active:
		current = clamp(current - delta/attack, 0.0, 1.0)
		
	if current == 0.0 and $Sample.playing:
		$Sample.stop()
		if has_node("EndSample"):
			$EndSample.play()
		
	$Sample.set_volume_db((-1.0 + current) * 100)