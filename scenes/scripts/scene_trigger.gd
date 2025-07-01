class_name SceneTrigger extends Area2D

@export var connected_scene: String
@export var entrance_point: String = "any"  # Точка входа в новой сцене

@onready var scene_manager = get_node("/root/scene_manager")

func _ready():
	# Подключаем сигнал, если он ещё не подключен
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Передаем текущую сцену, имя целевой сцены и точку входа
		scene_manager.change_scene(get_owner(), connected_scene, entrance_point)
