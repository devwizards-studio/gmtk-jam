extends Node2D
class_name Level

@export var player: Player
@export var game_timer: Timer

func _ready() -> void:
	player.game_timer = game_timer
	for upgrade in player.upgrade_arr:
		if upgrade != null:
			upgrade.connect("reduce_time", game_timer_reduce)

#for debugging time
func _process(delta: float) -> void:
	player.player_ui.label.text = str(game_timer.time_left)


func _on_game_timer_timeout() -> void:
	print("ai pierdut!")
	get_tree().quit()


func _on_end_area_body_entered(body: Node2D) -> void:
	if body is Player:
		print("you won! goingto next lvl..")
		get_tree().change_scene_to_file("res://Levels/Level2.tscn")

func game_timer_reduce(time_cost: float):
	print("the cost is: ", time_cost)
	print("time you had before the upgrade: ", game_timer.time_left)
	game_timer.start(game_timer.time_left - time_cost)
	print("time you have after the upgrade: ", game_timer.time_left)
