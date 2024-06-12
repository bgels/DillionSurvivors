extends Node2D

@onready var my_timer = $Timer
var counter = 0

func _ready():
	spawn_mob()
	
	
var enemy_list = [
	preload("res://Enemy/demon.tscn"),
	preload("res://Enemy/skeleton(2).tscn") 
	]

func spawn_mob():
	var counter = 1
	var enemy_spawn = randf_range(0, enemy_list.size())
	var scene = enemy_list[enemy_spawn].instantiate()
	%PathFollow2D.progress_ratio = randf()
	scene.position = %PathFollow2D.global_position
	add_child(scene)

func _on_timer_timeout():
	spawn_mob()
	


func _on_monster_enemy_died():
	counter += 1
	print(counter)
