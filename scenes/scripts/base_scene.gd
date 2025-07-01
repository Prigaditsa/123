class_name BaseScene extends Node

@onready var player : Player = null
@onready var entrance_markers: Node2D = $EntranceMarkers

func _ready() -> void:
	# Проверяем, определен ли игрок в SceneManager
	if get_node("/root/scene_manager").player:
		# Используем существующего игрока
		player = get_node("/root/scene_manager").player
		add_child(player)
		call_deferred("position_player")
		setup_camera()
	else:
		# Создаем нового игрока, если это первая сцена
		player = load("res://Игрок/player.tscn").instantiate()
		add_child(player)
		call_deferred("position_player")
		get_node("/root/scene_manager").player = player
		setup_camera()

func setup_camera() -> void:
	var camera = $Camera2D
	if camera and player:
		# Создаем RemoteTransform2D для игрока
		var remote_transform = RemoteTransform2D.new()
		player.add_child(remote_transform)
		# Устанавливаем путь к камере
		remote_transform.remote_path = camera.get_path()
		# Настраиваем, что передавать (позицию, вращение, масштаб)
		remote_transform.update_position = true
		remote_transform.update_rotation = false  # Можно включить, если нужно
		remote_transform.update_scale = false     # Можно включить, если нужно
		
		print("Camera setup completed")

func position_player() -> void:
	var last_scene = scene_manager.last_scene_name
	if last_scene.is_empty():
		last_scene = "any"
	
	var target_entrance = get_node("/root/scene_manager").entrance_point
	
	
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == target_entrance:
			
			player.global_position = entrance.global_position
			return
	
	# Если не нашли нужный маркер входа, используем первый доступный
	if entrance_markers.get_child_count() > 0:
		
		player.global_position = entrance_markers.get_child(0).global_position
