extends Reference

class_name WRandom

var total_weight:float = 0
var object_types:Array = []

func add_weight(val, weight:float):
	object_types.append(Weight.new(val, weight))

func pick():
	var weight:Weight = pick_some_object()
	if weight:
		return weight.value
	else:
		return null

func clear():
	total_weight = 0
	object_types.clear()

func init_probabilities() -> void:
	# Reset total_weight to make sure it holds the correct value after initialization
	total_weight = 0.0
	# Iterate through the objects
	for obj_type in object_types:
	  # Take current object weight and accumulate it
	  total_weight += obj_type.roll_weight
	  # Take current sum and assign to the object.
	  obj_type.acc_weight = total_weight

func pick_some_object() -> Weight:
	# Roll the number
	var roll: float = rand_range(0.0, total_weight)
	# Now search for the first with acc_weight > roll
	for obj_type in object_types:
		if (obj_type.acc_weight > roll):
			return obj_type

	# If here, something weird happened, but the function has to return a dictionary.
	return null
