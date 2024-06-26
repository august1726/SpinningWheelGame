// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Item(_free) constructor {
	descr = "Item"
	reusable = false;
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
	static spr = spr_health;
	descr = string("Health, Price: {0}\n+1 health if health 4 or less", price)
	use_action = function(_player, _spaces) {
		show_debug_message("Health")
		if (lives <= 4)
			lives++;
	}
}

function AddSpace(_free) : Item(_free) constructor {
	static spr = spr_add;
	descr = string("Plus, Price: {0}\nadd a space to the board", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Add Space")
		var _insert_idx = irandom(array_length(_spaces))
		var _idx1 = _insert_idx mod array_length(_spaces)
		var _idx2 = (_insert_idx + array_length(_spaces) - 1) mod array_length(_spaces)
		var _new_space = get_random_space([_spaces[_idx1], _spaces[_idx2]])
		_new_space.stock_items();
		
		array_insert(_spaces, _insert_idx, _new_space)
		if (_insert_idx <= _player.space) {
			_player.space++;
		}
		obj_spincard.section = 360 / array_length(_spaces)
		obj_spincard.calculate_pointers();
	}
}

function Jetpack(_free) : Item(_free) constructor {
	static spr = spr_jetpack;
	descr = string("Jetpack, Price: {0}\ntravel anywhere on the board", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Jet Pack")
		_player.movement = 999;
	}
}

function Vision(_free) : Item(_free) constructor {
	static spr = spr_eyes;
	descr = string("Vision, Price: {0}\nsee all dangerous spaces", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Vision")
		_player.vision = true;
		obj_spincard.calculate_pointers();
	}
}

function Reroll(_free) : Item(_free) constructor {
	static spr = spr_reroll;
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
		
		var _new_space1 = get_random_space([_spaces[_idx1], _spaces[_player.space]])
		_new_space1.stock_items();
		_new_space1.coins = _coins1;
		array_set(_spaces, _idx2, _new_space1)
		
		var _new_space2 = get_random_space([_spaces[_idx4], _spaces[_player.space]])
		_new_space2.stock_items();
		_new_space2.coins = _coins2;
		array_set(_spaces, _idx3, _new_space2)
		
		obj_spincard.calculate_pointers();
	}
}

function Delay(_free) : Item(_free) constructor {
	static spr = spr_delay;
	descr = string("Delay, Price: {0}\n delay next ptr add by 2 turns.", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Delay")
		_player.next_ptr += 2 //irandom_range(1, 2);
	}
}

function Blight(_free) : Item(_free) constructor {
	static spr = spr_blight;
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
	static spr = spr_intangible;
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

function Magnet(_free) : Item(_free) constructor {
	static spr = spr_magnet;
	descr = string("Magnet, Price: {0}\nCollects coins from the space with the most coins", price);
	use_action = function(_player, _spaces) {
		var _max_coins_space = max_coin_space(_spaces);
		_max_coins_space.collect_coins(_player);
	}
	static max_coin_space = function(_spaces) {
		var _max_coins_idx = 0;
		var _max_coins = _spaces[0].coins;

		for (var _i = 1; _i < array_length(_spaces); _i++) {
			if (_spaces[_i].coins > _max_coins) {
				_max_coins_idx = _i;
				_max_coins = _spaces[_i].coins;
			}
		}

		return _spaces[_max_coins_idx];
	}
}

function Shelf(_free) : Item(_free) constructor {
	static spr = spr_shelf;
	descr = string("Shelf, Price: {0}\n If space has an item slot, add one extra item slot.", price);
	use_action = function(_player, _spaces) {
		var _space = _spaces[_player.space]
		// _space.num_items != 0
		if (_space.num_items == array_length(_space.items)) {
			array_push(_space.items, noone);
		}
		
	}
}

function Choice(_free) : Item(_free) constructor {
	static spr = spr_choice;
	reusable = true;
	choose_spaces = noone;
	idx = false;
	descr = string("Choice\n Allows player to pick out of 2 spaces.");
	use_action = function(_player, _spaces) {
		var _space = _spaces[_player.space]
		if (choose_spaces == noone) {
			_player.choice = self;
			var _n = array_length(_spaces)
			var _idx1 = (_player.space - 1 + _n) mod _n
			var _idx2 = (_player.space + 1 + _n) mod _n
			var _new_space1 = get_random_space([_spaces[_idx1], _spaces[_idx2], _space])
			_new_space1.stock_items();
			var _new_space2 = get_random_space([_spaces[_idx1], _spaces[_idx2], _space, _new_space1])
			_new_space2.stock_items();
			choose_spaces = [_new_space1, _new_space2]
		}
		
		_spaces[_player.space] = choose_spaces[idx];
		obj_spincard.clear_shop();
		obj_spincard.calibrate_shop();
		idx = !idx
		descr = string("Choice\n Changes current space to option #{0}.", idx+1);
		
		obj_spincard.calibrate_inventory();
		obj_spincard.calculate_pointers();
		
	}
}

function Insurance(_free) : Item(_free) constructor {
	static spr = spr_insurance;
	descr = string("Insurance, Price: {0}\nIf you are hit by a pointer next turns, Take 1 less damage.", price);
	use_action = function(_player, _spaces) {
		_player.insurance = true;
	}
}

function Shell(_free) : Item(_free) constructor {
	static spr = spr_turtle;
	descr = string("Shell, Price: {0}\nreduce all damage by pointers to 1 next turn", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Shell")
		_player.shell = true;
	}
}

function Inspect(_free) : Item(_free) constructor {
	static spr = spr_inspect;
	descr = string("Jetpack, Price: {0}\ntravel anywhere on the board", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Inspect")
		_player.inspect = true;
	}
}

function Reset(_free) : Item(_free) constructor {
	static spr = spr_reset;
	descr = string("Reset, Price: {0}\nPointers reset all items for the spaces they land on next turn.", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Reset")
		_player.reset_items = true;
	}
}

function Diminish(_free) : Item(_free) constructor {
	static spr = spr_diminish;
	descr = string("Diminish, Price: {0}\nNext item used this turn will have a decreased probability of showing up on the board. Intangible & Choice not included.", price);
	use_action = function(_player, _spaces) {
		show_debug_message("Diminish")
		_player.diminish = true;
	}
}


