class_name box1 extends Node

@onready var health_component: Node = $HealthComponent


func _ready():
	$HitBox.Damaged.connect( TakeDamage )
	pass



func TakeDamage( _damage : int ) -> void:
	health_component.take_damage(5)
	pass
