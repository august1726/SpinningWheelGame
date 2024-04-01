// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Item() constructor {
	spr = spr_health;
	descr = "Item"
	if (obj_spincard.turn_num == 0) {
		price = 3;
	} else {
		price = 3 + (floor(obj_spincard.turn_num/3 + obj_spincard.player.coins/5));
	}
	use_action = function(_player, _spaces) {
		
	}
}

function HealthUp() : Item() constructor {
	spr = spr_health;
	descr = string("Health, Price: {0}\nheal 1 health", price)
	use_action = function(_player, _spaces) {
		show_debug_message("Health")
		lives++;
	}
}

function AddSpace() : Item() constructor {
	spr = spr_add;
	descr = string("Plus, Price: {0}\nadd a space to the board", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Add Space")
		var _insert_idx = irandom(array_length(_spaces))
		var _idx1 = _insert_idx mod array_length(_spaces)
		var _idx2 = (_insert_idx + array_length(_spaces) - 1) mod array_length(_spaces)
		var _new_space = get_random_space(_spaces[_idx1], _spaces[_idx2])
		_new_space.stock_items();
		
		array_insert(_spaces, _insert_idx, _new_space)
		if (_insert_idx <= _player.space) {
			_player.space++;
		}
		obj_spincard.section = 360 / array_length(_spaces)
		if (_player.sight_prob > 0) {
			obj_spincard.show_pointers();
		}
	}
}

function Jetpack() : Item() constructor {
	spr = spr_jetpack;
	descr = string("Jetpack, Price: {0}\ntravel anywhere on the board", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Jet Pack")
		_player.movement = 999;
	}
}

function Vision() : Item() constructor {
	spr = spr_eyes;
	descr = string("Vision, Price: {0}\nsee all dangerous spaces", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Vision")
		_player.sight_prob = 1;
		obj_spincard.show_pointers();
	}
}

function Reroll() : Item() constructor {
	spr = spr_reroll;
	descr = string("Reroll, Price: {0}\nrandomize adjacent spaces. coins are kept.", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Reroll")
		var _n = array_length(_spaces)
		var _idx1 = (_player.space - 2 + _n) mod _n
		var _idx2 = (_player.space - 1 + _n) mod _n
		var _idx3 = (_player.space + 1 + _n) mod _n
		var _idx4 = (_player.space + 2 + _n) mod _n
		
		var _coins1 = ceil(_spaces[_idx2].coins);
		var _coins2 = ceil(_spaces[_idx3].coins);
		
		var _new_space1 = get_random_space(_spaces[_idx1], _spaces[_player.space])
		_new_space1.stock_items();
		_new_space1.coins = _coins1;
		array_set(_spaces, _idx2, _new_space1)
		
		var _new_space2 = get_random_space(_spaces[_idx4], _spaces[_player.space])
		_new_space2.stock_items();
		_new_space2.coins = _coins2;
		array_set(_spaces, _idx3, _new_space2)
	}
}

function Delay() : Item() constructor {
	spr = spr_delay;
	descr = string("Delay, Price: {0}\nincrease turns till next pointer by 1.", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Delay")
		_player.next_ptr++;
	}
}