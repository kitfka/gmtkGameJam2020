extends Node


var usableKeys = [
	KEY_0,
	KEY_1,
	KEY_2,
	KEY_3,
	KEY_4,
	KEY_5,
	KEY_6,
	KEY_7,
	KEY_8,
	KEY_9
]

func _ready():
	for i in range(65, 91):
		usableKeys.append(i)
	print(usableKeys)
