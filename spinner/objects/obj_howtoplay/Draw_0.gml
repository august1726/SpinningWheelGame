draw_how_to_play();

draw_set_color(c_white)
draw_rectangle(button_x1, button_y1, button_x2, button_y2, false)
if (point_in_rectangle(mouse_x, mouse_y, button_x1, button_y1, button_x2, button_y2)) {
	if (mouse_check_button_pressed(mb_left)) {
		room = rm_game
		audio_stop_sound(snd_mus_howto);
	}
}

draw_set_color(c_purple)
draw_rectangle(button_x1, button_y1, button_x2, button_y2, true)
draw_text_color(room_width/2, y2+button_height/2, "Proceed", c_purple, c_purple, c_purple, c_purple, 1)


