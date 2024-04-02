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

function shift_val(_col) {
	return make_color_hsv(color_get_hue(_col), color_get_saturation(_col), color_get_value(_col) / 3);
}

function get_random_space(_space1, _space2) {
	start = false;
	space_type = GreySpace;
	while (!start or is_instanceof(_space1, space_type) or is_instanceof(_space2, space_type)) {
		space_type = obj_spincard.spaces_list[irandom_range(0, array_length(obj_spincard.spaces_list)-1)];
		start = true;
	}
	return new space_type();
};

function draw_how_to_play(_x1 = room_width/30, _y1 = room_height/12, _x2 = room_width - _x1, _y2 = room_height - _y1) {
	static howto_text = "Click on a colored space on the wheel to start\nYou can move to adjacent spaces every turn\nSpaces you can move to are shown lighter than spaces you cannot move to\nHover over different spaces and power-ups to see what properties they have.\nPlayers can buy power-ups when on their space\nPrices of new power-ups are dependent on turn number and player's wealth.\nPower-ups and coins spawn on the space where a pointer lands\nIf a pointer lands on the player's space, they take 1 damage (per pointer)\nIf you reach 0 health, you lose\nIf you reach 30 rounds, you win\nThere is 1 pointer to begin with, and an additional pointer is added every 5 rounds"
	draw_roundrect_color(_x1, _y1, _x2, _y2, c_white, c_white, false)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fnt_menu)
	draw_text_ext_color(room_width/2, room_height/8, "How to play:", 20, _x2-_x1, c_fuchsia, c_fuchsia, c_fuchsia, c_fuchsia, 1);
	draw_set_font(fnt_default)
	draw_text_ext_color(room_width/2, room_height/2+UNIT/2, howto_text, 20, _x2-_x1, c_purple, c_purple, c_purple, c_purple, 1);
}