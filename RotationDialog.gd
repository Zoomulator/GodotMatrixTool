tool
extends PopupPanel

signal commit_rotation(v, phi)

func get_value(node_name):
	var text = find_node(node_name).text
	var expr = Expression.new()
	var err = expr.parse(text)
	if err != OK:
		push_error(expr.get_error_text())
		return NAN
	var value = expr.execute()
	if expr.has_execute_failed():
		return NAN
	return value

func _on_Button_pressed():
	var x = get_value("X")
	var y = get_value("Y")
	var z = get_value("Z")
	var phi = get_value("Phi")
	emit_signal("commit_rotation", Vector3(x,y,z), phi)
