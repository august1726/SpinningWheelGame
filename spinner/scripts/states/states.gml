// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function choose_start(){
	if mouse_check_button_pressed(mb_left) {
		mouse_dist = point_distance(x, y, mouse_x, mouse_y);
		if (sprite_width/2 < mouse_dist and mouse_dist < line_length) {
			var _dir = point_direction(x, y, mouse_x, mouse_y)
			var _clicked_space = clamp(_dir div section, 0, array_length(spaces)-1)
			player.space = _clicked_space;
			state = STATES.INITIATE_TURN;
		}
	}
}

function initiate_turn() {
	turn_num++;
	if (turn_num >= WIN_THRESHOLD) {
		state = STATES.WIN;
	} else {
		player.next_ptr--;
		if (player.next_ptr <= 0) {
			array_push(pointer_dirs, 0)
			player.reset_countdown();
		}
		if (lives <= 0) {
			state = STATES.DEATH;
		} else {
			player.reset_movement();
			player.sight_prob = 0;
			warning_list = []
			spaces[player.space].collect_coins(player);
			spaces[player.space].player_action(player);
			for (var _i = 0; _i < array_length(pointer_dirs); _i++) {
				pointer_dirs[_i] = irandom_range(0, 359)
			}
			obj_spincard.show_pointers();
		
			for (var _i = 0; _i < spaces[player.space].num_items; _i++ ) {
				shop_card[_i].item = spaces[player.space].items[_i]
				shop_card[_i].space_inventory = spaces[player.space].items
			}
		
			if (lives <= 0) {
				state = STATES.DEATH;
			} else {
				state = STATES.PLAYER_TURN;
			}
		}
	}
}

function show_pointers() {
	for (var _i = 0; _i < array_length(pointer_dirs); _i++) {
		pointer_dirs[_i] = irandom_range(0, 359)
		var _space_idx = clamp(pointer_dirs[_i] div section, 0, array_length(spaces)-1)
		if (!array_contains(warning_list, _space_idx) and random(1) < player.sight_prob) {
			array_push(warning_list, _space_idx);
		}
	}
}

function player_turn(){
	
	if mouse_check_button_pressed(mb_left) {
		mouse_dist = point_distance(x, y, mouse_x, mouse_y);
		if (sprite_width/2 < mouse_dist and mouse_dist < line_length) {
			var _dir = point_direction(x, y, mouse_x, mouse_y)
			var _clicked_space = clamp(_dir div section, 0, array_length(spaces)-1)
			var _spaces_away = get_wrap_dist(player.space, _clicked_space, array_length(spaces))
			//show_debug_message("player: {0}, click: {1}, dist: {2}", player.space, _clicked_space, _spaces_away)
			if (_spaces_away != 0 and _spaces_away <= player.movement) {
				player.space = _clicked_space;
				state = STATES.SPIN;
			}
		}
	}
}


function spin(){
	for (var _i = 0; _i < array_length(pointer_dirs); _i++) {
		var _space_idx = clamp(pointer_dirs[_i] div section, 0, array_length(spaces)-1)
		spaces[_space_idx].pointer_action();
		spaces[_space_idx].stock_items(items_list);
		if (player.space == _space_idx) {
			lives--;
		}
		
	}
	for (var _i = 0; _i < instance_number(obj_shop_card); ++_i;)
		{
		    shop_card[_i].item = noone;
		}
	
	alarm[0] = game_get_speed(gamespeed_fps)*2;
	audio_play_sound(snd_spinners, 10, false);
	state = STATES.WAIT;
}

function wait() {
	
}

function win(){
	in_play = false;
	alarm[1] = game_get_speed(gamespeed_fps)*1;
	state = STATES.WAIT;
}

function death(){
	in_play = false;
	alarm[2] = game_get_speed(gamespeed_fps)*1;
	state = STATES.WAIT;
}