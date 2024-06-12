extends Area2D

#stats
var speed = 400
var max_distance = 999
var distance_traveled = 0
var direction = Vector2.ZERO
var damage = 25
signal dead

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))
	rotate_bullet()

func _physics_process(delta):
	var movement = direction * speed * delta
	distance_traveled += movement.length()
	position += movement
	if distance_traveled >= max_distance:
		queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		return
	elif body.is_in_group("monster"):
		body.take_damage(damage)
	queue_free()
	dead.emit()

func rotate_bullet():
	rotation = direction.angle()
