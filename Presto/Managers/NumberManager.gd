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

func presti_reset():
	time_factor = 5
	number = 0
	cost_base = 4
	presti_count += 1
	expontent= presti_count

func increase_numer(num  = 1):
	number += num
	time_factor -= (0.001 * presto)

func button_runtime():
	var base = expontent
	if expontent == 0:
		base =1
	var val = int(10/base)
	if val < 0.1:
		val = 0.1
	return val
	
func get_button_value(num):
	return int(num / growth_rate)+1

func _process(delta: float) -> void:
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
