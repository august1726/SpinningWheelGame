// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Item(_free) constructor {
	spr = spr_health;
	descr = "Item"
	if (_free) {
		price = 0;
	} else if (obj_spincard.turn_num == 0) {
		price = 3;
	} else {
		price = 3 + (floor(obj_spincard.turn_num/3 + obj_spincard.player.coins/5));
	}
	use_action = function(_player, _spaces) {
		
	}
}

function HealthUp(_free) : Item(_free) constructor {
	spr = spr_health;
	descr = string("Health, Price: {0}\n+1 health", price)
	use_action = function(_player, _spaces) {
		show_debug_message("Health")
		lives++;
	}
}

function AddSpace(_free) : Item(_free) constructor {
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

function Jetpack(_free) : Item(_free) constructor {
	spr = spr_jetpack;
	descr = string("Jetpack, Price: {0}\ntravel anywhere on the board", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Jet Pack")
		_player.movement = 999;
	}
}

function Vision(_free) : Item(_free) constructor {
	spr = spr_eyes;
	descr = string("Vision, Price: {0}\nsee all dangerous spaces", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Vision")
		_player.sight_prob = 1;
		obj_spincard.show_pointers();
	}
}

function Reroll(_free) : Item(_free) constructor {
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

function Delay(_free) : Item(_free) constructor {
	spr = spr_delay;
	descr = string("Delay, Price: {0}\n delay next ptr add by 1-2 turns.", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Delay")
		_player.next_ptr += irandom_range(1, 2);
	}
}

function Blight(_free) : Item(_free) constructor {
	spr = spr_blight;
	price = 0;
	descr = string("Blight\n-1 health. no effect if used on grey space");
	use_action = function(_player, _spaces) {
		show_debug_message("Blight")
		_player.take_damage();
		if (lives <= 0)
				obj_spincard.state = STATES.DEATH;
	}
}

function Intangible(_free) : Item(_free) constructor {
	spr = spr_intangible;
	intangible_length = 2;
	descr = string("Intangible, Price: {0}\ntake no damage for 2 turns.\ndestroy every other intangible", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Intangible")
		_player.intangible += intangible_length;
		for (var _i = 0; _i < array_length(_spaces); _i++) {
			if (is_instanceof(_spaces[_i], IntangibleSpace)) {
				_spaces[_i].items[0] = noone;
			}
		}
		
		obj_spincard.calibrate_shop();
		
		for (var _i = 0; _i < array_length(_player.inventory); _i++) {
			if (is_instanceof(_player.inventory[_i], Intangible)) {
				_player.inventory[_i] = noone;
			}
		}
		
		obj_spincard.calibrate_inventory();
	}
}