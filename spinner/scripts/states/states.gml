// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function choose_start(){
	if mouse_check_button_pressed(mb_left) {
		mouse_dist = point_distance(x, y, mouse_x, mouse_y);
		if (sprite_width/2 < mouse_dist and mouse_dist < LINE_LENGTH) {
			player.space = mouse_space;
			state = STATES.INITIATE_TURN;
		}
	}
}

function initiate_turn() {
	if (!is_instanceof(spaces[player.space], FreezeSpace)) {
		turn_num++;
	}
	
	if (turn_num >= win_threshold) {
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
			player.reset_attributes();
			player.remove_choice();
			player.subtract_intangible();
			spaces[player.space].collect_coins(player);
			spaces[player.space].player_action(player, spaces);
			player.use_repeats(player, spaces);
			if (!is_instanceof(spaces[player.space], FreezeSpace)) {
				for (var _i = 0; _i < array_length(pointer_dirs); _i++) {
					pointer_dirs[_i] = irandom_range(0, array_length(spaces)-1)*section + section/2 + random_range(-1, 1)*section/6
				}
			}
			obj_spincard.calculate_pointers();
		
			calibrate_shop();
		
			if (lives <= 0) {
				state = STATES.DEATH;
			} else {
				state = STATES.PLAYER_TURN;
			}
		}
	}
}

function player_turn(){
	
	if mouse_check_button_pressed(mb_left) {
		mouse_dist = point_distance(x, y, mouse_x, mouse_y);
		if (sprite_width/2 < mouse_dist and mouse_dist < LINE_LENGTH) {
			var _spaces_away = get_wrap_dist(player.space, mouse_space, array_length(spaces))
			//show_debug_message("player: {0}, click: {1}, dist: {2}", player.space, _clicked_space, _spaces_away)
			if ((_spaces_away != 0 or player.inspect) and _spaces_away <= player.movement) {
				var _stayed = player.space == mouse_space;
				var _space = spaces[player.space];
				player.space = mouse_space;
				
				if (!_stayed and is_instanceof(_space, SwapSpace)) {
					swap_spaces(_space, spaces)
					obj_spincard.calculate_pointers();
				}
				
				if (!is_instanceof(spaces[player.space], FreezeSpace)) {
					state = STATES.SPIN;
				} else {
					state = STATES.INITIATE_TURN;
					obj_spincard.clear_shop();
				}
			}
		}
	}
	
	if mouse_check_button_pressed(mb_right) {
		var _list = []
		for (var _i = 0; _i < array_length(spaces); _i++) {
			array_push(_list, find_type(spaces[_i], spaces_list));
		}
		
		_list = array_unique(_list)
		
		for (var _i = 0; _i < array_length(_list); _i++) {
			array_push(_list, (_list[_i]));
		}
		
	}
}

function swap_spaces(_swap_space, _spaces) {
	var _n = array_length(_spaces)
	var _available = array_create(0)
	for (var _i = 0; _i < _n; _i++) {
		if (_i != player.space and _i != _swap_space.idx) {
			var _adj1 = (_i - 1 + _n) mod _n
			var _adj2 = (_i + 1 + _n) mod _n
			if (!is_instanceof(_spaces[_adj1], SwapSpace) and !is_instanceof(_spaces[_adj2], SwapSpace)) {
				array_push(_available, _i)
			}
		}
	}
	
	var _num_available = array_length(_available)
	if (_num_available > 0) {
		var _chosen = _available[irandom(_num_available-1)]
		
		var _temp = _spaces[_swap_space.idx]
		_spaces[_swap_space.idx] = _spaces[_chosen]
		_spaces[_chosen] = _temp;
	}
}


function spin(){
	for (var _i = 0; _i < array_length(spaces); _i++) {
		if (spaces[_i].num_pointers >= 1) {
			spaces[_i].stock_items(player.reset_items);
		}
		spaces[_i].spin_action();
		//show_debug_message("Player: {0}, Pointer: {1}, Section: {2}, Length: {3}", player.space, _space_idx, section, array_length(spaces));
		
		if (player.space == _i) {
			player.take_pointer_damage(spaces[_i].num_pointers);
		}
	}
	obj_spincard.clear_shop();
	
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