extends TextureProgressBar

@onready var player =  $"../../Player"

func _ready():
	max_value = 100
	player.healthChanged.connect(self.updateHealth)
	player.playerDeath.connect(self.deathSequence) # the signals
	updateHealth()

func updateHealth():
	print(player.health)
	value = player.health + 16
	
func deathSequence():
	get_tree().change_scene_to_file("res://Menui/End.tscn")
	print("GAME OVER")
