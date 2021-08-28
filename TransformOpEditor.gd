extends EditorProperty


const RotationDialog = preload("RotationDialog.tscn")

var rotate_btn = Button.new()
var copy_btn = Button.new()
var paste_btn = Button.new()
var current_value = Transform()
var updating = false


func _init():
	var btnbox = HBoxContainer.new()
	for btn in [rotate_btn, copy_btn, paste_btn]:
		btnbox.add_child(btn)
		add_focusable(btn)
	add_child(btnbox)
	set_bottom_editor(btnbox)
	rotate_btn.text = "Rotate"
	rotate_btn.connect("pressed", self, "_on_button_pressed")
	copy_btn.text = "Copy"
	copy_btn.connect("pressed", self, "_on_copy_pressed")
	paste_btn.text = "Paste"
	paste_btn.connect("pressed", self, "_on_paste_pressed")

func _on_button_pressed():
	if (updating):
		return
	prompt_rotate()

func update_property():
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == current_value):
		return
	updating = true
	current_value = new_value
	updating = false

func prompt_rotate():
	var popup = RotationDialog.instance()
	popup.connect("popup_hide", popup, "queue_free")
	popup.connect("commit_rotation", self, "rotate")
	add_child(popup)
	var x = get_parent().get_global_rect().position.x
	var y = get_global_rect().position.y
	var width = get_parent().get_rect().size.x
	popup.popup(Rect2(x, y, width, 50))

func rotate(v: Vector3, phi: float):
	current_value = current_value.rotated(v, phi)
	emit_changed(get_edited_property(), current_value)

func _on_copy_pressed():
	OS.clipboard = var2str(current_value)

func _on_paste_pressed():
	var value = str2var(OS.clipboard)
	if value is Transform:
		current_value = value
		emit_changed(get_edited_property(), current_value)
	else:
		push_error("Tried to paste bad transform: %s" % [value])
