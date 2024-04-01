x1 = room_width/30
y1 = room_height/12
x2 = room_width - x1
y2 = room_height - y1

button_half_width = 64;
button_height = 32;

button_x1 = room_width/2 - button_half_width
button_y1 = y2
button_x2 = room_width/2 + button_half_width
button_y2 = y2 + button_height

music = snd_mus_howto
audio_play_sound(music, 10, true)