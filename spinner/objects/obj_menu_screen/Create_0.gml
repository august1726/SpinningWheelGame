x = room_width/2
y = room_height/2
if (!variable_instance_exists(id, "colors")) {
	colors = [c_red, c_orange, c_yellow, c_green, c_blue, c_purple]
}
section_angle = 360 / array_length(colors);
dir_offset = 0;
dir_offset_max = 360
length = room_width
circle_width = 128

play_button_width = 192
play_button_height = 64
button_x = x
button_y = y + (UNIT*2)
x1 = button_x - play_button_width/2
y1 = button_y - play_button_height/2
x2 = button_x + play_button_width/2
y2 = button_y + play_button_height/2
color_idx = 2
hover = false;

if (!variable_instance_exists(id, "title")) {
	title = "Spin to Lose!"	
}
if (!variable_instance_exists(id, "button_text")) 
{
	button_text = "Play"
}

if (room == rm_start_menu) {
	room_dest = rm_howto;
} else {
	room_dest = rm_game;
}


if (room == rm_lose) {
	music = snd_mus_lose;
} else {
	music = snd_mus_menu;
}

audio_play_sound(music, 10, true);