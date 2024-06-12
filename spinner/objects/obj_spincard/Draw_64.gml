
if position_meeting(mouse_x, mouse_y, obj_probs_sign) {
	var _items_to_display = array_filter(item_probs, is_positive)
	var _num_items = array_length(_items_to_display)
	
	var _x = room_width/2 - (1/2)*(_num_items-1)*UNIT;
	
	var _x1 = room_width/2 - (1/2)*(_num_items)*UNIT;
	var _y1 = obj_probs_sign.y + UNIT
	var _x2 = room_width/2 + (1/2)*(_num_items)*UNIT;
	var _y2 = obj_probs_sign.y - UNIT/2
	draw_set_color(c_white);
	draw_rectangle(_x1, _y1, _x2, _y2, false)
	
	for (var _i = 0; _i < array_length(items_list); _i++ ) {
		if (item_probs[_i] > 0) {
			draw_set_color(c_white);
			draw_sprite(item_sprs[_i], 0, _x, obj_probs_sign.y + UNIT/2)
			draw_set_color(c_black);
			draw_text(_x, obj_probs_sign.y, item_probs[_i] == PROB_MAX ? "MAX": string(item_probs[_i]))
			_x += UNIT;
		}
	}
} else {
	draw_set_color(c_black);
	draw_text(obj_probs_sign.x, obj_probs_sign.y, "Probabilities")	
}