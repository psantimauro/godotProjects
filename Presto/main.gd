extends Node2D
const CLICKABLE_TIMER_PROGRESS_BAR = preload("res://clickable_timer_progress_bar.tscn")
const CLICKER = preload("res://clicker.tscn")
@onready var button: Button = %Button
@onready var button_container: GridContainer = $VBoxContainer
@onready var _0: ClickableProgressBar = $"VBoxContainer/0"

@export var btn_text = "Clic"
@export var btn_alt_text = "No Clic"

var btn_num = 1
var max_button_num = 78

func _ready() -> void:
	load_game()
	_0.done.connect(_on_0_button_pressed)
	NumberManager.new_button_unlocked.connect(make_new_button)
	NumberManager.presto_enable.connect(enable_presto)
	NumberManager.next_cost_change.connect(update_cost_next)
	NumberManager.growth_rate_change.connect(update_growth_rate)
	NumberManager.expontent_change.connect(update_expontent)
	NumberManager.number_change.connect(update_number)
	await button.ready
	button.text = btn_text
	await _0.ready
	_0.btn_text = btn_text
	_0.btn_timeout_text = btn_alt_text

func update_number(number):
	%Value.text = str(int(number))
func update_expontent(expontent):
	%Exponent.text = "Exponent: "+ str(expontent)
func update_growth_rate(growth_rate = 0):
	%growth_factor.text = "Growth Factor: %.3f " % (growth_rate)
func update_cost_next ( next = 0):
	%Cost.text = "Next Cost: " + str(int(next))
		
func _on_0_button_pressed(_btn):
	NumberManager.increase_numer()
	if _0.is_stopped():
	#	_0.run_time = NumberManager.button_runtime()	
		_0.start()
var first = true
func _on_button_pressed() -> void:
	if first == true: 
		first = false
		var clicker = CLICKER.instantiate()
		clicker.clicked.connect(_on_cliker_clicked)
		add_child(clicker)
		clicker.position = Vector2(117,83)	
	#if !_0.visible:
		_0.show()
	NumberManager.increase_numer()

func make_new_button():
	if btn_num > max_button_num:
		_on_presto_pressed()
		
	var btn = CLICKABLE_TIMER_PROGRESS_BAR.instantiate()
	button_container.add_child(btn)
	btn.add_to_group("Persist")
	btn.one_shot = true
	btn.run_time = NumberManager.button_runtime(btn_num)
	btn.name =  str(btn_num)
	btn.btn_text = btn_text
	btn.btn_timeout_text = btn_alt_text
	btn.done.connect(_on_clickable_press)	
	btn_num +=1

var clicker_count  =1

func _on_cliker_clicked(pos):
	for button in button_container.get_children():
		var button_min = button.position
		var button_max = button_min+ button.size
		if button_min <= pos and pos <= button_max:
			if button.name == "Button":
				button.emit_signal("pressed")
			else:
				button.click(NumberManager.get_button_value(int(button.name)))
	

func _on_clickable_press(btn):
		var previous_button = int(btn.name) - 1
		var val = NumberManager.get_button_value(previous_button)
		NumberManager.increase_numer(val)
		if previous_button == -1:
			button.emit_signal("pressed")
		else:
			var Prev_button = button_container.get_node(str(previous_button))
			Prev_button.click(val)
		#	if Prev_button.is_stopped():
				#Prev_button.run_time = NumberManager.button_runtime()		
		#		Prev_button.start()
		#	else:
		#		Prev_button.click(val)

func _on_presto_pressed() -> void:
	NumberManager.increase_presto(1)
	%PrestoBar.value += 1
	if %PrestoBar.value == 10 :
		presti()
		
func enable_presto():
	%PrestoButton.show()
	%PrestoBar.show()

func presti():
	%PrestoBar.set_value_no_signal(0)
	_0.stop()
	%PrestoButton.hide()
	%PrestoBar.hide()
	NumberManager.presti_reset()
	for child in button_container.get_children():
		var number = int(child.name)
		if number > 0:
			child.queue_free()
	btn_num = 1

func _on_save_button_pressed() -> void:
	save_game()
	save_managers()

func save_game(filename = "savegame"):
	var save_file = FileAccess.open("user://%s.save" % filename, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")

	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)

func save_managers():
	var save_file = FileAccess.open("user://savegame_managers.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("PersistManager")

	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

func load_game():
	load_managers()
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	_0.show() # alittle haky
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = CLICKABLE_TIMER_PROGRESS_BAR.instantiate()
		button_container.add_child(new_object)
		
		new_object.load(node_data)
		print("Loading button %s" % new_object.name )
		if new_object.name == "0":
			_0 = new_object
			new_object.done.connect(_on_0_button_pressed)
		else:
			new_object.done.connect(_on_clickable_press)
		new_object.show()

func load_managers():
	if not FileAccess.file_exists("user://savegame_managers.save"):
		return # Error! We don't have a save to load.
	var save_nodes = get_tree().get_nodes_in_group("PersistManagers")

	var save_file = FileAccess.open("user://savegame_managers.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.data

		var name = node_data["name"]
		var manager = get_tree().root.get_node(name)
		manager.load(node_data)
