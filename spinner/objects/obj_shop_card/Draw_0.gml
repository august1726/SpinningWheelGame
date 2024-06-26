var _up = true;
if (item != noone) {
	if (position_meeting(mouse_x, mouse_y, id)) {
		draw_set_color(c_ltgray);
		if (item != noone) { obj_item_descr.text = item.descr; }
		if (mouse_check_button_pressed(mb_left)) {
			if (item != noone and player.coins >= item.price and array_contains(player.inventory, noone)) {
				player.coins -= item.price;
				audio_play_sound(snd_buy, 10, false);
				array_set(space_inventory, array_get_index(space_inventory, item), noone)
				array_set(player.inventory, array_get_index(player.inventory, noone), item)
				show_debug_message("inventory: {0}", player.inventory);
				item = noone;
				obj_spincard.calibrate_shop();
				obj_spincard.calibrate_inventory();
			}
			_up = false
		}
	} else {
		draw_set_color(c_white);
	}
}

if (item != noone) {
	draw_button(x - sprite_width/2, y - sprite_height/2, x + sprite_width/2, y + sprite_height/2, _up)

	draw_set_color(c_white)
	draw_sprite(spr_coin, 0, x, y + sprite_height/2);
	
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(c_black)
	draw_text(x, y + sprite_height/2, string("{0}", item.price))

	draw_sprite_ext(item.spr, 0, x, y, 2, 2, 0, c_white, 1)
}





