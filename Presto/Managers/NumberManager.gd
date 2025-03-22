extends Node

signal new_button_unlocked
signal presto_enable
signal next_cost_change
signal growth_rate_change
signal expontent_change
signal number_change

var time_factor = 5
var presto = 0
var presti_count = 1

var growth_rate = 1.007:
	set(g):
		growth_rate = g
		growth_rate_change.emit(growth_rate)
var cost_base = 4
var cost_next = cost_base
var expontent = 0:
	set(e):
		expontent = e
		expontent_change.emit(expontent)
var number = 0:
	set(n):
		number = n
		number_change.emit(number)

func _ready() -> void:
	add_to_group("PersistManager")
	
func _process(_delta: float) -> void:
	cost_next = cost_base * pow(growth_rate ,expontent)
	next_cost_change.emit(cost_next)
	if cost_next < number: 
		new_button_unlocked.emit()
		expontent += 1
		cost_base = cost_next
		growth_rate += 0.001
		number -= cost_next
	if expontent >= 9:
		presto_enable.emit()

func save() -> Dictionary:
	var number_manager_save = {
		"name": "NumberManager",
		"time_factor": time_factor,
		"presto": presto,
		"presti_count": presti_count,
		"growth_rate": growth_rate,
		"cost_base": cost_base,
		"expontent": expontent,
		"number": number
	}
	return number_manager_save

func load(number_manager_save: Dictionary):
	time_factor = number_manager_save["time_factor"]
	presto = number_manager_save["presto"]
	presti_count = number_manager_save["presti_count"]
	growth_rate = number_manager_save["growth_rate"]
	cost_base = number_manager_save["cost_base"]
	expontent = number_manager_save["expontent"]
	number = number_manager_save["number"]
	
func presti_reset():
	time_factor = 5
	number = 0
	cost_base = 4
	presti_count += 1
	expontent= presti_count

func increase_numer(num  = 1):
	number += num
	time_factor -= (0.001 * presto)

func increase_presto(amt = 1):
	presto += amt
	
func button_runtime(btn_number = 0):
	var base = expontent
	if expontent == 0:
		base =1
	var val = pow(btn_number,growth_rate)
	if val < 0.1:
		val = 0.1
	return val
	
func get_button_value(num):
	return int(num / growth_rate)+1
