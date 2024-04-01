for (var _space = 0; _space < array_length(colors); _space++) {
	var _x1 = x + lengthdir_x(length, round(section_angle*_space) + dir_offset)
	var _y1 = y + lengthdir_y(length, round(section_angle*_space ) + dir_offset)
	var _x2 = x + lengthdir_x(length, round(section_angle*(_space+1)) + dir_offset + 5)
	var _y2 = y + lengthdir_y(length, round(section_angle*(_space+1)) + dir_offset + 5)
	
	draw_triangle_color(x, y, _x1, _y1, _x2, _y2, colors[_space], colors[_space], colors[_space], false);
}
dir_offset = (mouse_x/room_width * 360);

draw_circle_color(x, y, circle_width, c_white, c_white, false);

draw_set_halign(fa_center)
draw_set_valign(fa_bottom)
draw_set_font(fnt_menu)
draw_text_ext_color(x, y, title, 15, room_width, colors[0], colors[1], colors[3], colors[4], 1);

draw_set_color(colors[color_idx])
if (point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y2)) {
	draw_button(x1, y1, x2, y2, true);
	if (hover == false) {
		color_idx = (color_idx + 1) mod array_length(colors)
		hover = true;
	}
	if (mouse_check_button_pressed(mb_left)) {
		draw_button(x1, y1, x2, y2, false);
		audio_stop_sound(music);
		room = room_dest
	}
} else {
	draw_button(x1, y1, x2, y2, true);
	hover = false;
}

draw_set_valign(fa_middle)
draw_set_color(c_black)
draw_text(button_x, button_y, button_text)