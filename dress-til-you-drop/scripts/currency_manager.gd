extends Node

# currency manager - singleton to track player currency across scenes
var currency: int = 0

signal currency_changed(new_amount: int)

func add_currency(amount: int) -> void:
	currency += amount
	currency_changed.emit(currency)

func spend_currency(amount: int) -> bool:
	if currency >= amount:
		currency -= amount
		currency_changed.emit(currency)
		return true
	return false

func get_currency() -> int:
	return currency

func set_currency(amount: int) -> void:
	currency = amount
	currency_changed.emit(currency)
