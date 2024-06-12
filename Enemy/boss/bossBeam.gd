extends RayCast2D

@onready var casting_particles: GPUParticles2D = $CastingParticles
@onready var collision_particles_2: GPUParticles2D = $CollisionParticles2
@onready var beam_particle_2d: GPUParticles2D = $BeamParticle2D

@onready var damage_area: Area2D = $Area2D  # Reference to the Area2D node
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D  # Reference to the CollisionShape2D node


@export var damage = 20
var direction = Vector2.ZERO

var is_casting: bool = false :
	set(value): 
		is_casting = value
		
		beam_particle_2d.emitting = is_casting
		casting_particles.emitting = is_casting
		
		if is_casting:
			appear()
		else:
			collision_particles_2.emitting = false
			disapear()
		set_physics_process(is_casting)


func _ready():
	is_casting = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		self.is_casting = event.pressed

func _physics_process(delta: float) -> void:
	var cast_point := target_position
	rotation = direction.angle()
	force_raycast_update()
	
	collision_particles_2.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles_2.global_rotation = get_collision_normal().angle()
		collision_particles_2.position = cast_point
	
	$Line2D.points[1] = cast_point
	beam_particle_2d.position = cast_point * 0.5
	beam_particle_2d.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		shape.extents = Vector2(cast_point.length() * 0.5, beam_particle_2d.process_material.emission_box_extents.y)
		damage_area.position = cast_point * 0.5

func appear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 90, 0.2)


func disapear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
