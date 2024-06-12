extends CharacterBody2D
class_name Player

@onready var root_node = get_parent()
@onready var shootTime: Timer = $can_shoot
@onready var iframe: Timer = $iframe
@onready var damageArea = $Hitbox
@onready var music =  $music
@onready var bossmusic = $bossmusic
signal healthChanged
signal playerDeath
#Stats
@export var maxHealth = 100
@onready var health: int = maxHealth
@export var speed = 400
var invincible: bool = false
# Weapon
@export var BulletScene : PackedScene
var bulletOffset = 50
var is_shooting = false
func _ready():
	add_to_group("player")
	root_node.jimmyspawn.connect(self.bossMusic)
	music.play()
	print(root_node)
	print("Ok")
	iframe.connect("timeout", Callable(self, "_on_iframe_timeout"))
	damageArea.connect("area_entered", Callable(self, "_on_area_entered"))

func startIframe():
	invincible = true
	iframe.start()

func _on_iframe_timeout():
	invincible = false

func take_damage(x):
	if not invincible:
		health -= x
		healthChanged.emit()
		print(health)
		if health <= 0:
			playerDeath.emit()
		else:
			startIframe()

func _on_area_entered(body):
	print(body)
	if body.is_in_group("playerDamaging") and invincible == false: # ensure that the area2d node in the monster has a group called playerDamaging
		take_damage(15)
		startIframe()
		print("dmg")
		print("Iframe start")

func get_input():
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction.normalized() * speed
	if velocity == Vector2.ZERO:
		pass
	else:
		$AnimationTree.set("parameters/blend_position", velocity)
	if Input.is_action_just_pressed("shoot"):
		if not is_shooting:
			shootTime.start()
			is_shooting = true
	elif Input.is_action_just_released("shoot"):
			if is_shooting:
				shootTime.stop()
				is_shooting = false

func shoot(position_tar):
	$shot.play()
	var bullet = BulletScene.instantiate()
	owner.add_child(bullet)
	
	var startingPosition = position + (position_tar - position).normalized() * bulletOffset
	
	bullet.position = startingPosition
	bullet.direction = (position_tar - position).normalized()
	bullet.rotate_bullet()

func _physics_process(_delta):
	get_input()
	move_and_slide()

func bossMusic():
	print("BOSS MUISC CHANGE")
	$music.stop()
	bossmusic.play()
	return
func _on_can_shoot_timeout():
	var pos = get_global_mouse_position()
	shoot(pos)
