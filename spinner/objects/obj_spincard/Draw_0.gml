draw_set_color(c_white)
draw_circle(x, y, LINE_LENGTH, false);
draw_set_color(c_black)
draw_circle(x, y, LINE_LENGTH-UNIT, false);
draw_set_color(c_white)


// draw color segment, player, items, and coins.
for (var _space = 0; _space < array_length(spaces); _space++) {
	// draw_color segment
	space = spaces[_space];
	
	var _x1 = x + lengthdir_x(LINE_LENGTH, section*_space)
	var _y1 = y + lengthdir_y(LINE_LENGTH, section*_space )
	var _x2 = x + lengthdir_x(LINE_LENGTH, section*(_space+1))
	var _y2 = y + lengthdir_y(LINE_LENGTH, section*(_space+1))
	
	var _col = space.color
	if (get_wrap_dist(player.space, _space, array_length(spaces)) > player.movement and state != STATES.CHOOSE_START) {
		_col = space.shifted_color
	}
	draw_triangle_color(x, y, _x1, _y1, _x2, _y2, _col, _col, _col, false);
	if (point_in_triangle(mouse_x, mouse_y, x, y, _x1, _y1, _x2, _y2)) {
		mouse_space = _space;
	}
	
	
	draw_set_alpha(1);

	//var _dir = section * (_space + .5)
	//var _x2 = x + lengthdir_x(LINE_LENGTH, _dir)
	//var _y2 = y + lengthdir_y(LINE_LENGTH, _dir)
	//var _col = c_black
	//draw_line_width_color(x, y, _x2, _y2, 3, _col, _col);
	
	var _coin_dir = section * (_space + .5)
	var _coin_x = x + lengthdir_x(SPACING*5, _coin_dir)
	var _coin_y = y + lengthdir_y(SPACING*5, _coin_dir)
	
	draw_sprite(spr_coin, 0, _coin_x, _coin_y)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(c_black)
	draw_text(_coin_x, _coin_y, string(space.coins));
	
	draw_set_color(c_white)
	
	if(array_contains(warning_list, _space) and state = STATES.PLAYER_TURN) {
		var _warning_dir = section * (_space + .25)
		var _warning_x = x + lengthdir_x(SPACING*3, _warning_dir)
		var _warning_y = y + lengthdir_y(SPACING*3, _warning_dir)
		draw_set_color(c_white)
		draw_sprite_ext(spr_warning,  0, _warning_x, _warning_y, 1, 1, _warning_dir, c_white, 1)
	}
	
	for (var _i = 0; _i < space.num_items; _i++) {
		if (space.items[_i] != noone) {
			var _item_dir = section * (_space + .5)
			var _item_x = x + lengthdir_x(SPACING*(3+_i), _item_dir)
			var _item_y = y + lengthdir_y(SPACING*(3+_i), _item_dir)
		
			draw_sprite(space.items[_i].spr, 0, _item_x, _item_y)
			var _w = sprite_get_width(space.items[_i].spr)/2
			if (point_in_rectangle(mouse_x, mouse_y, _item_x-_w, _item_y-_w, _item_x+_w, _item_y+_w)) {
				obj_item_descr.text = space.items[_i].descr;
			}
		}
	}
}

draw_set_color(c_yellow)
draw_text(obj_coin_text.x, obj_coin_text.y, string("Coins: {0}", player.coins))

if (lives <= 1) {
	draw_set_color(c_red)	
} else if (lives == 2) {
	draw_set_color(c_yellow)	
} else {
	draw_set_color(c_lime)
}
draw_text(obj_lives_text.x, obj_lives_text.y, string("Lives: {0}", lives))

draw_set_color(c_white)

if (state == STATES.WAIT and in_play) {
	for (var _i = 0; _i < array_length(pointer_dirs); _i++) {
		
		var _col = make_color_hsv(0, 0, lerp(127, 255,  (1-_i/(array_length(pointer_dirs)-1)) ))
		if (array_length(pointer_dirs) == 1) {
			_col = c_white
		}
		
		draw_sprite_ext(spr_pointer, 0, x, y, 1, 1, pointer_dirs[_i], _col, 1);
	}
}

if (state != STATES.CHOOSE_START and state != STATES.DEATH) {
	var _player_dir = section * (player.space + .5)
	var _player_x = x + lengthdir_x(SPACING*2, _player_dir)
	var _player_y = y + lengthdir_y(SPACING*2, _player_dir)
	
	draw_sprite(spr_player, 0, _player_x, _player_y)
	var _w = sprite_get_width(spr_player)
	if (point_in_rectangle(mouse_x, mouse_y, _player_x-_w, _player_y-_w, _player_x+_w, _player_y+_w)) {
		obj_item_descr.text = "Player\n This is you!"
	}
}

draw_self()

draw_text(obj_ptrtimer.x + obj_ptrtimer.sprite_width/2, obj_ptrtimer.y + obj_ptrtimer.sprite_height/2, string("Add pointer in {0}", player.next_ptr));
draw_text(obj_ptrcount.x + obj_ptrcount.sprite_width/2, obj_ptrcount.y + obj_ptrcount.sprite_height/2, string("{0} pointers", array_length(pointer_dirs)));
draw_text(obj_turndisp.x + obj_turndisp.sprite_width/2, obj_turndisp.y + obj_turndisp.sprite_height/2, string("Turn: {0}/{1}", turn_num, WIN_THRESHOLD));
draw_text(obj_statedisp.x + obj_statedisp.sprite_width/2, obj_statedisp.y + obj_statedisp.sprite_height/2, state_descrs[state]);
draw_text(obj_shopsign.x + obj_shopsign.sprite_width/2, obj_shopsign.y + obj_shopsign.sprite_height/2, string("Shop"));
draw_text(obj_invsign.x + obj_invsign.sprite_width/2, obj_invsign.y + obj_invsign.sprite_height/2, string("Inventory"));

mouse_dist = point_distance(x, y, mouse_x, mouse_y);
if (sprite_width/2 < mouse_dist and mouse_dist < LINE_LENGTH) {
	var _dir = point_direction(x, y, mouse_x, mouse_y)
	var _hover_descr = spaces[mouse_space].descr
	obj_space_descr.text = _hover_descr;
	obj_space_descr.col = spaces[mouse_space].color
}