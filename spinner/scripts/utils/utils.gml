// assumes that a and b are integers within 0 to wrap length
function get_wrap_dist(_a, _b, _n) {
	if (_a > _b) {
		return min(_a - _b, _n - (_a - _b));
	} else if (_a < _b) {
		return min(_b - _a, _n - (_b - _a));
	} else {
		return 0;	
	}
}

function is_even(_num) {
	return (_num mod 2 == 0);
}

function draw_triangle_custom(_x1, _y1, _x2, _y2, _x3, _y3, _col, _line_width, _outline = true) {
  // Check if outline argument is true (defaults to true)
  if (_outline) {
    // Set the line color before drawing
    draw_set_color(_col);  // Assuming you want same color for all sides
    
    // Draw each side of the triangle with the specified line width
    draw_line_width(_x1, _y1, _x2, _y2, _line_width);
    draw_line_width(_x2, _y2, _x3, _y3, _line_width);
    draw_line_width(_x3, _y3, _x1, _y1, _line_width);
  } else {
    // If outline is false, use draw_triangle with original coloring
    draw_triangle_colour(_x1, _y1, _x2, _y2, _x3, _y3, _col, _col, _col, _outline);
  }
}

function get_random_space(_spaces) {
	space_type = noone;
	do {
		space_type = obj_spincard.spaces_list[irandom_range(0, array_length(obj_spincard.spaces_list)-1)];
	}
	until (!is_one_of_space(space_type, _spaces));
	return new space_type();
};

function is_one_of_space(_type, _spaces) {
	for (var _i = 0; _i < array_length(_spaces); _i++) {
		if (is_instanceof(_spaces[_i], _type)) {
			return true;
		}
	}
	return false;
}

function find_item_type(_item, _types) {
	for (var _i = 0; _i < array_length(_types); _i++) {
		if (is_instanceof(_item, _types[_i])) {
			return _i;
		}
	}
	return -1;
}

function draw_how_to_play(_x1 = room_width/30, _y1 = room_height/12, _x2 = room_width - _x1, _y2 = room_height - _y1) {
	static howto_text = "Click on a colored space on the wheel to start\nYou can move to adjacent spaces every turn\nSpaces you can move to are shown lighter than spaces you cannot move to\nHover over different spaces and power-ups to see what properties they have\nPlayers can buy power-ups when on their space\nPrices of new power-ups are dependent on turn number and player's wealth\nPower-ups and coins spawn on the space where a pointer lands\nIf a pointer lands on the player's space, they take 1 damage (per pointer)\nIf you reach 0 health, you lose\nIf you reach turn 30, you win\nThere is 1 pointer to begin with, and an additional pointer is added every 5 rounds"
	draw_roundrect_color(_x1, _y1, _x2, _y2, c_white, c_white, false)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fnt_menu)
	draw_text_ext_color(room_width/2, room_height/8, "How to play:", 20, _x2-_x1, c_fuchsia, c_fuchsia, c_fuchsia, c_fuchsia, 1);
	draw_set_font(fnt_default)
	draw_text_ext_color(room_width/2, room_height/2+UNIT/2, howto_text, 20, _x2-_x1, c_purple, c_purple, c_purple, c_purple, 1);
}

function get_triangle_space(_dir, _section, _num_spaces) {
	
	var _point_x = x + lengthdir_x(UNIT, _dir)
	var _point_y = y + lengthdir_y(UNIT, _dir)
	
	for (var _space = 0; _space < _num_spaces; _space++) {
		var _x1 = x + lengthdir_x(LINE_LENGTH/2, _section*_space)
		var _y1 = y + lengthdir_y(LINE_LENGTH/2, _section*_space)
		var _x2 = x + lengthdir_x(LINE_LENGTH/2, _section*(_space+1))
		var _y2 = y + lengthdir_y(LINE_LENGTH/2, _section*(_space+1))
		
		if (point_in_triangle(_point_x, _point_y, x, y, _x1, _y1, _x2, _y2)) {
			show_debug_message(_space);
			return _space;
		}
	}
	return 0
}

function display_probs() {
	
}