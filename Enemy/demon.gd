extends CharacterBody2D
signal dead

#stats
@export var speed = 45 # slider to the right
@export var health = 150

@onready var player = get_tree().get_first_node_in_group("player")
@onready var spawner = get_parent()
func _ready():
	add_to_group("monster")

func _physics_process(_delta):
	velocity = global_position.direction_to(player.global_position).normalized() * speed
	move_and_slide()

func take_damage(amount):
	health -= amount
	if health <= 0:
		print("demonemitted")
		dead.emit()
		queue_free()




