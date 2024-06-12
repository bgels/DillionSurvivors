extends CharacterBody2D

#stats
@export var speed = 25 # slider to the right
@export var health = 500
@onready var player = get_tree().get_first_node_in_group("player")
@onready var world = $"."
#attacks
#basic bullet
@export var boss_bullet : PackedScene
@export var bulletOffset = 120
@onready var bulletTimer: Timer = $bulletTimer
# wave attack
var basicAttackCount = 0
@export var boss_wave : PackedScene
# beam attack
@export var boss_beam : PackedScene
@onready var beamTimer: Timer = $beamTimer
var beam_attack: Node2D
var waveAttackCount = 0


	
func _ready():
	bulletTimer.connect("timeout", Callable(self, "_on_bulletTimer_timeout"))
	bulletTimer.start()
	beam_attack = boss_beam.instantiate()
	add_child(beam_attack)
	beam_attack.is_casting = false
	beam_attack.visible = false


func _physics_process(_delta):
	$Control/ProgressBar.value = health / 5
	velocity = global_position.direction_to(player.global_position).normalized() * speed
	move_and_slide()

func take_damage(amount):
	health -= amount
	$bossDamaged.play()
	if health <= 0:
		print("Boss Dead dead")
		queue_free()

func _on_bulletTimer_timeout():
	var bullet = boss_bullet.instantiate()
	var playerpos = player.global_position
	
	bullet.position = position + (playerpos - position).normalized() * (bulletOffset * randf_range(0, 1))
	bullet.direction = (playerpos - position).normalized()
	
	get_parent().add_child(bullet)
	bullet.rotate_bullet()
	increase_basicAttack_count()

func waveAttack():
	var bullet = boss_wave.instantiate()
	var playerpos = player.global_position
	
	bullet.position = position + (playerpos - position).normalized() * bulletOffset
	bullet.direction = (playerpos - position).normalized()
	
	get_parent().add_child(bullet)
	bullet.rotate_bullet()
	increase_waveAttack_count()

func beamAttack():
	$bossWave.play()
	if not beam_attack.is_casting:
		beam_attack.is_casting = true
		beam_attack.visible = true
	beamTimer.start()
	var direction = (player.global_position - position).normalized()
	update_beam_direction()

func update_beam_direction():
	var direction = (player.global_position - global_position).normalized()
	beam_attack.direction = direction

func _on_beam_timer_timeout():
	if beam_attack.is_casting:
		beam_attack.is_casting = false
		beam_attack.visible = false


func increase_basicAttack_count():
	basicAttackCount += 1
	if basicAttackCount >= 9:
		basicAttackCount = 0
		waveAttack()
func increase_waveAttack_count():
	waveAttackCount += 1
	if waveAttackCount >= 2:
		waveAttackCount = 0
		beamAttack()
