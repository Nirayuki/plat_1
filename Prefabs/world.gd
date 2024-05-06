extends Node2D

func _on_playagain_pressed():
	get_tree().reload_current_scene()
