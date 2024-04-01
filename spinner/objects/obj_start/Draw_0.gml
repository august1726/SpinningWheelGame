draw_text(room_width/2, room_height/2, text);

if (mouse_check_button_pressed(mb_left) and !clicked) {
	clicked = true;
	alarm[0] = game_get_speed(gamespeed_fps);
}

