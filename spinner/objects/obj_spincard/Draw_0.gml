draw_set_color(c_white)
//draw_circle(x, y, LINE_LENGTH, false);
draw_set_color(c_black)
draw_circle(x, y, LINE_LENGTH-UNIT, false);
draw_set_color(c_white)

// draw color segment, player, items, and coins.
for (var _space = 0; _space < array_length(spaces); _space++) {
	// draw_color segment
	draw_set_color(c_black)
	space = spaces[_space];
	space.idx = _space;
	
	var _x1 = x + lengthdir_x(LINE_LENGTH, section*_space)
	var _y1 = y + lengthdir_y(LINE_LENGTH, section*_space )
	var _x2 = x + lengthdir_x(LINE_LENGTH, section*(_space+1))
	var _y2 = y + lengthdir_y(LINE_LENGTH, section*(_space+1))
	
	if (is_array(space.colors)) {
		for (var _i = 0; _i < array_length(space.colors); _i++) {
			var _col = space.colors[_i]
			var _ll = LINE_LENGTH*(array_length(space.colors)-_i)/array_length(space.colors)
			var _tx1 = x + lengthdir_x(_ll, section*_space)
			var _ty1 = y + lengthdir_y(_ll, section*_space )
			var _tx2 = x + lengthdir_x(_ll, section*(_space+1))
			var _ty2 = y + lengthdir_y(_ll, section*(_space+1))
			draw_triangle_color(x, y, _tx1, _ty1, _tx2, _ty2, _col, _col, _col, false);
		}
		
		if (get_wrap_dist(player.space, _space, array_length(spaces)) > player.movement and state != STATES.CHOOSE_START) {
			draw_set_alpha(0.3);
			draw_triangle_color(x, y, _x1, _y1, _x2, _y2, c_black, c_black, c_black, false);
			draw_set_alpha(1);
		}
		
		if (array_length(spaces) <= 4) {
			var _x3 = x + lengthdir_x(LINE_LENGTH, section*(_space+0.5))
			var _y3 = y + lengthdir_y(LINE_LENGTH, section*(_space+0.5))
			draw_triangle_custom(_x1, _y1, _x2, _y2, _x3, _y3, space.colors[0], 1, false);
		}
		
	} else {
		var _col = space.colors
		draw_triangle_color(x, y, _x1, _y1, _x2, _y2, c_black, c_black, c_black, false);
		if (get_wrap_dist(player.space, _space, array_length(spaces)) > player.movement and state != STATES.CHOOSE_START) {
			draw_set_alpha(DARKEN)
		}
		
		draw_triangle_color(x, y, _x1, _y1, _x2, _y2, _col, _col, _col, false);
		
		if (array_length(spaces) <= 4) {
			var _x3 = x + lengthdir_x(LINE_LENGTH, section*(_space+0.5))
			var _y3 = y + lengthdir_y(LINE_LENGTH, section*(_space+0.5))
			draw_triangle_custom(_x1, _y1, _x2, _y2, _x3, _y3, _col, 1, false);
		}
	}
	draw_set_alpha(1)
	
	
	if (point_in_triangle(mouse_x, mouse_y, x, y, _x1, _y1, _x2, _y2)) {
		mouse_space = _space;
	}
	
	// vision display
	if((player.vision and space.num_pointers >= 1) and state = STATES.PLAYER_TURN) {
		var _warning_dir = section * (_space + .5)
		var _warning_x = x + lengthdir_x(SPACING*3, _warning_dir)
		var _warning_y = y + lengthdir_y(SPACING*3, _warning_dir)
		draw_set_color(c_white)
		draw_sprite_ext(spr_warning,  0, _warning_x, _warning_y, 1, 1, _warning_dir, c_white, 1)
	}
	
	// inspect display
	if (player.inspect and state = STATES.PLAYER_TURN) {
		if (get_wrap_dist(player.space, _space, array_length(spaces)) <= 1) {
			var _warning_dir = section * (_space + .5)
			var _inspect_x = x + lengthdir_x(SPACING*5, _warning_dir)
			var _inspect_y = y + lengthdir_y(SPACING*5, _warning_dir)
			draw_set_alpha(0.5);
			draw_sprite(spr_inspect_display,  0, _inspect_x, _inspect_y)
			draw_set_color(c_black)
			draw_text(_inspect_x , _inspect_y, string(space.num_pointers));
			draw_set_color(c_white)
			draw_set_alpha(1);
		}
	}
}


// items display.
for (var _space = 0; _space < array_length(spaces); _space++) {
	space = spaces[_space];
	for (var _i = 0; _i < array_length(space.items); _i++) {
		var _item_dir = section * (_space + .5)
		//var _item_x = x + lengthdir_x(SPACING*(3+(_i*0.5)+(0.5*is_even(_space))), _item_dir)
		//var _item_y = y + lengthdir_y(SPACING*(3+(_i*0.5)+(0.5*is_even(_space))), _item_dir)
		var _item_x = x + lengthdir_x(SPACING*(3.5+(_i*0.5)), _item_dir)
		var _item_y = y + lengthdir_y(SPACING*(3.5+(_i*0.5)), _item_dir)
		
		if (space.items[_i] != noone) {
			draw_sprite(space.items[_i].spr, 0, _item_x, _item_y)
			var _w = sprite_get_width(space.items[_i].spr)/2
			if (point_in_rectangle(mouse_x, mouse_y, _item_x-_w, _item_y-_w, _item_x+_w, _item_y+_w)) {
				obj_item_descr.text = space.items[_i].descr;
			}
		} else {
			draw_sprite(spr_empty, 0, _item_x, _item_y)
		}
	}
	
	var _x1 = x + lengthdir_x(LINE_LENGTH, section*_space)
	var _y1 = y + lengthdir_y(LINE_LENGTH, section*_space )
	var _x2 = x + lengthdir_x(LINE_LENGTH, section*(_space+1))
	var _y2 = y + lengthdir_y(LINE_LENGTH, section*(_space+1))
	
	if (state == STATES.PLAYER_TURN) {
		var _dist = get_wrap_dist(player.space, _space, array_length(spaces))
		if (state != STATES.CHOOSE_START and (_dist != 0 or player.inspect) and _dist <= player.movement) {
			var _width = clamp(6 - floor(array_length(spaces)/15), 1, 6);
			draw_triangle_custom(x, y, _x1, _y1, _x2, _y2, c_white, _width);
		}
	}
	
	var _coin_dir = section * (_space + .5)
	var _coin_x = x + lengthdir_x(SPACING*5.5, _coin_dir)
	var _coin_y = y + lengthdir_y(SPACING*5.5, _coin_dir)
	
	draw_sprite_ext(spr_coin, 0, _coin_x, _coin_y, 0.5, 0.5, 0, c_white, 1)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(c_black)
	draw_text(_coin_x, _coin_y, string(space.coins));
	draw_set_color(c_white)
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
	var _player_x = x + lengthdir_x(SPACING*1.5, _player_dir)
	var _player_y = y + lengthdir_y(SPACING*1.5, _player_dir)
	var _scale =  2-((array_length(spaces)-num_start_spaces)/(max_spaces-num_start_spaces))
	
	if (player.intangible == 0) {
		draw_sprite_ext(spr_player, (lives <= 0), _player_x, _player_y, _scale, _scale, 0, c_white, 1)
	} else if (player.intangible > 0) {
		draw_sprite_ext(spr_player, 2, _player_x, _player_y, _scale, _scale, 0, c_white, 1)
		draw_text(_player_x, _player_y, string(player.intangible))
	}
	
	if (player.shell)
		draw_sprite(spr_turtle, 0, x + lengthdir_x(SPACING*1.25, _player_dir), y + lengthdir_y(SPACING*1.25, _player_dir))
	
	if (player.insurance)
		draw_sprite(spr_insurance, 0, x + lengthdir_x(SPACING*1.75, _player_dir), y + lengthdir_y(SPACING*1.75, _player_dir))
	
	var _w = sprite_get_width(spr_player)
	if (point_in_rectangle(mouse_x, mouse_y, _player_x-_w, _player_y-_w, _player_x+_w, _player_y+_w)) {
		obj_item_descr.text = "Player\n This is you!"
	}
}

draw_self()

draw_text(obj_ptrtimer.x + obj_ptrtimer.sprite_width/2, obj_ptrtimer.y + obj_ptrtimer.sprite_height/2, string("Add pointer in {0}", player.next_ptr));
draw_text(obj_ptrcount.x + obj_ptrcount.sprite_width/2, obj_ptrcount.y + obj_ptrcount.sprite_height/2, string("{0} pointers", array_length(pointer_dirs)));
draw_text(obj_turndisp.x + obj_turndisp.sprite_width/2, obj_turndisp.y + obj_turndisp.sprite_height/2, string("{0} spaces",  array_length(spaces)));
draw_text(x, y, string("{0}", win_threshold-turn_num));
draw_text(obj_statedisp.x + obj_statedisp.sprite_width/2, obj_statedisp.y + obj_statedisp.sprite_height/2, state_descrs[state]);
draw_text(obj_shopsign.x + obj_shopsign.sprite_width/2, obj_shopsign.y + obj_shopsign.sprite_height/2, string("Shop"));
draw_text(obj_invsign.x + obj_invsign.sprite_width/2, obj_invsign.y + obj_invsign.sprite_height/2, string("Inventory"));

mouse_dist = point_distance(x, y, mouse_x, mouse_y);
if (sprite_width/2 < mouse_dist and mouse_dist < LINE_LENGTH) {
	var _dir = point_direction(x, y, mouse_x, mouse_y)
	var _hover_descr = spaces[mouse_space].descr
	obj_space_descr.text = _hover_descr;
	//obj_space_descr.col = spaces[mouse_space].colors[0]
}