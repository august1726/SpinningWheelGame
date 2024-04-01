var _up = true;
if (position_meeting(mouse_x, mouse_y, id)) {
	draw_set_color(c_ltgray);
	if (item != noone) { obj_item_descr.text = item.descr; }
	if (mouse_check_button_pressed(mb_left)) {
		if (item != noone and obj_spincard.state = STATES.PLAYER_TURN) {
			audio_play_sound(snd_use, 10, false)
			obj_spincard.use_item(i);
			item = noone;
		}
		_up = false
	}
} else {
	draw_set_color(c_white);
}
draw_button(x, y, x + sprite_width, y + sprite_height, _up)

if (item != noone) {
	draw_self();

	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_sprite_ext(item.spr, 0, x + sprite_width/2, y + sprite_height/2, 2, 2, 0, c_white, 1)
}
