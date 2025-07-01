class_name table extends Node2D

@onready var health_component: Node = $HealthComponent
@onready var sprite: Sprite2D = $Sprite2D
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_destroyed = false
var damage_stage = 0  # Текущая стадия разрушения (0-1)
var max_damage_stages = 2  # Максимальное количество стадий

func _ready():
	$HitBox.Damaged.connect(TakeDamage)
	health_component.died.connect(OnDestroyed)
	
	# Устанавливаем здоровье так, чтобы хватило на 2 удара
	health_component.max_health = max_damage_stages * 5  # 10 HP = 2 удара по 5 урона
	health_component.current_health = health_component.max_health

func TakeDamage( hurt_box : HurtBox ) -> void:
	if is_destroyed:
		return
		
	health_component.take_damage(5)
	
	# Вычисляем текущую стадию разрушения
	var new_damage_stage = max_damage_stages - int(ceil(float(health_component.current_health) / 5.0))
	
	# Если стадия изменилась, проигрываем соответствующую анимацию
	if new_damage_stage != damage_stage and new_damage_stage < max_damage_stages:
		damage_stage = new_damage_stage
		PlayDamageStageAnimation()

func PlayDamageStageAnimation() -> void:
	var animation_name = ""
	
	match damage_stage:
		1:
			animation_name = "damage_stage_1"  # Единственная стадия повреждения
	
	# Проверяем, есть ли такая анимация
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)
	else:
		# Если нет отдельных анимаций стадий, делаем простой эффект
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)

func OnDestroyed() -> void:
	if is_destroyed:
		return
		
	is_destroyed = true
	
	# Отключаем коллизию
	static_body.set_collision_layer_value(5, false)  # layer 16 = bit 5
	
	# Запускаем финальную анимацию разрушения
	animation_player.play("destroy")
	
	# Подключаемся к сигналу завершения анимации для удаления объекта
	if not animation_player.animation_finished.is_connected(OnDestroyAnimationFinished):
		animation_player.animation_finished.connect(OnDestroyAnimationFinished)

func OnDestroyAnimationFinished(animation_name: StringName) -> void:
	if animation_name == "destroy":
		queue_free()

# Опциональная функция для получения текущей стадии разрушения
func get_damage_stage() -> int:
	return damage_stage

# Опциональная функция для получения процента здоровья
func get_health_percentage() -> float:
	return float(health_component.current_health) / float(health_component.max_health)
