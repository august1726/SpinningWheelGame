// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function Space() constructor {
	type = 0;
	descr = "Space"
	color = c_white;
	shifted_color = shift_val(color);
	num_items = 1;
	items = array_create(num_items, noone)
	start_coins = 3;
	coins = start_coins;
	static collect_coins = function(_player) {
		_player.coins += coins;
		coins = 0;
	}
	static player_action = function(_player, _spaces = noone) {
		
	}
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN, GOLD_MAX)
	}
	static stock_items = function() {
		for (var _i = 0; _i < array_length(items); _i++) {
			if(items[_i] == noone) {
				var _item_type = obj_spincard.items_list[irandom_range(0, array_length(obj_spincard.items_list)-1)];
				items[_i] = new _item_type(is_instanceof(self, OrangeSpace) && _i == 0);
			}
		}
	}
}

function RedSpace() : Space() constructor {
	color = c_red;
	shifted_color = shift_val(color);
	descr = "Red Space\ntake damage upon entering. gold drops on this square doubled."
	static player_action = function(_player, _spaces = noone) {
		_player.take_damage();
	}
	
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN, GOLD_MAX)*2
	}
}

function OrangeSpace() : Space() constructor {
	color = c_orange;
	shifted_color = shift_val(color);
	num_items = 1;
	items = array_create(num_items, noone)
	descr = "Orange Space\ncontains one free item. gold drops on this square halved."
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN/2, GOLD_MAX/2);
	}
}

function YellowSpace() : Space() constructor {
	color = c_yellow;
	shifted_color = shift_val(color);
	num_items = 2;
	items = array_create(num_items, noone)
	descr = "Yellow Space\ncontains 1 extra item for sale"
}

function GreenSpace() : Space() constructor {
	color = c_green;
	shifted_color = shift_val(color);
	descr = "Green Space\ngain 1 health upon entering if health is 2 or less."
	static player_action = function(_player, _spaces = noone) {
		if (lives <= HEAL_MAX) {
			lives += 1;
			audio_play_sound(snd_heal, 10, false);
		}
	}
}

function BlueSpace() : Space() constructor {
	color = c_blue;
	shifted_color = shift_val(color);
	descr = "Blue Space\nsee all dangerous spaces for next turn"
	static player_action = function(_player) {
		_player.sight_prob = 1;
	}
}

function PurpleSpace() : Space() constructor {
	color = c_purple;
	shifted_color = shift_val(color);
	descr = "Purple Space\ntravel up to 2 adjacent spaces, rather than just 1"
	static player_action = function(_player) {
		_player.movement = 2;
	}
}

function GreySpace() : Space() constructor {
	color = c_grey;
	shifted_color = shift_val(color);
	descr = "Disable Space:\n Only blight can be used on this space."
}

function HospitalSpace() : Space() constructor {
	color = c_teal;
	shifted_color = shift_val(color);
	descr = "Hospital Space:\n Gives a blight (damage 1), then a heart (heal 1) to player."
	static player_action = function(_player, _spaces = noone) {
		if (array_contains(_player.inventory, noone)) {
			array_set(_player.inventory, array_get_index(_player.inventory, noone), new Blight(true))
		}
		
		if (array_contains(_player.inventory, noone)) {
			array_set(_player.inventory, array_get_index(_player.inventory, noone), new HealthUp(true))
		}
		obj_spincard.calibrate_inventory();
	}
}

function DoubleSpace() : Space() constructor {
	color = c_fuchsia;
	shifted_color = shift_val(color);
	num_items = 0;
	items = array_create(num_items, noone)
	descr = "Double Space:\n Items used on this space will be activated again on the following turn."
}

function IntangibleSpace() : Space() constructor {
	color = c_navy;
	shifted_color = shift_val(color);
	num_items = 1;
	items = array_create(num_items, noone)
	descr = "Intangible Space:\n Contains Intangible."
	static stock_items = function() {
		for (var _i = 0; _i < array_length(items); _i++) {
			if(items[_i] == noone and obj_spincard.player.intangible == 0) {
				items[_i] = new Intangible(false);
			}
		}
	}
}

function BlindSpace() : Space() constructor {
	color = c_black;
	shifted_color = shift_val(color);
	num_items = 0;
	items = array_create(num_items, noone)
	descr = "Blind Space:\n Turns into a random space upon entering."
	static player_action = function(_player, _spaces) {
		var _n = array_length(_spaces);
		var _idx1 = (_player.space - 1 + _n) mod _n
		var _idx2 = (_player.space + 1 + _n) mod _n
		
		var _coins = coins
		var _new_space = get_random_space(_spaces[_idx1], _spaces[_idx2], _spaces[_player.space])
		_new_space.stock_items();
		_new_space.coins = _coins;
		
		var _ghost_space = _spaces[_player.space]
		array_delete(_spaces, _player.space, 1)
		array_insert(_spaces, _player.space, _new_space)
		
		_new_space.player_action(_player, _spaces);
		
		//var _add_space = new AddSpace(true);
		//_add_space.use_action(_player, _spaces);
		
	}
}

function FreezeSpace() : Space() constructor {
	color = c_white;
	shifted_color = shift_val(color);
	num_items = 1;
	items = array_create(num_items, noone)
	descr = "Freeze Space:\n Pointers will not activate on this space. Turn counter will not progress on this space. Item buffs will still ware off."
}