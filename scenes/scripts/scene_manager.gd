class_name SceneManager extends Node

var player: Player
var scene_dir_path = "res://scenes/"
var entrance_point = "any"
var last_scene_name: String

# Вызываем эту функцию для перехода между сценами
func change_scene(from, to_scene_name: String, entrance: String = "any") -> void:
	last_scene_name = from.name
	# Сохраняем точку входа
	entrance_point = entrance
	
	# Сохраняем ссылку на игрока и удаляем его из текущей сцены
	player = from.player
	player.get_parent().remove_child(player)
	
	# Формируем полный путь к новой сцене
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	
	# Используем отложенную замену сцены для безопасности
	from.get_tree().call_deferred("change_scene_to_file", full_path)
	
	# Ожидаем загрузку новой сцены перед добавлением игрока
	await from.get_tree().process_frame
	
	# Обратите внимание: игрок будет добавлен в BaseScene._ready()

# Получить текущую активную сцену
func get_current_scene():
	return get_tree().current_scene
