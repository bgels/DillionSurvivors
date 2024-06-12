extends Area2D

# stats
var speed = 600
var max_distance = 2400
var distance_traveled = 0
var direction = Vector2.ZERO
var damage = 35

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
		body.take_damage(damage)
		queue_free()
	else:
		return

func rotate_bullet():
	rotation = direction.angle()
	print("shot wave")
