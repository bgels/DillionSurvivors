extends CharacterBody2D

#stats
@export var speed = 45 # slider to the right
@export var health = 50
@onready var player = get_tree().get_first_node_in_group("player")
@onready var spawner = get_parent()
#attacks
var bulletOffset = 500
#AutoAttacks
@onready var bullet:Timer = $bulletAttack
@onready var bossBullet: PackedScene = preload("res://Enemy/boss/bossBullet.tscn")

func _physics_process(_delta):
	velocity = global_position.direction_to(player.global_position).normalized() * speed
	move_and_slide()

func take_damage(amount):
	health -= amount
	basicAttack()
	if health <= 0:
		print("ded")
		queue_free()

func basicAttack():
	var pos = player.global_position
	var startingPosition = position + (pos - position).normalized() * bulletOffset
	var bulletAtk = bossBullet.instantiate()
	self.add_child(bulletAtk)
	
	
	bulletAtk.position = startingPosition
	bulletAtk.direction = (pos - position).normalized()
	bulletAtk.rotate_bullet()
	

