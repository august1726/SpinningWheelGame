// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function Space() constructor {
	type = 0;
	descr = "Space"
	color = c_white;
	shifted_color = shift_val(color);
	num_items = 1;
	items = array_create(num_items, noone)
	coins = irandom(3);
	static collect_coins = function(_player) {
		_player.coins += coins;
		coins = 0;
	}
	static player_action = function(_player) {
		
	}
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN, GOLD_MAX)
	}
	static stock_items = function() {
		for (var _i = 0; _i < array_length(items); _i++) {
			if(items[_i] == noone) {
				var _item_type = obj_spincard.items_list[irandom_range(0, array_length(obj_spincard.items_list)-1)];
				items[_i] = new _item_type();
			}
		}
	}
}

function GreySpace() : Space() constructor {
	color = c_grey;
	type = 7;
	shifted_color = shift_val(color);
	descr = "Neutral Space"
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN, GOLD_MAX)
		
	}
}

function RedSpace() : Space() constructor {
	color = c_red;
	shifted_color = shift_val(color);
	type = 0;
	descr = "Red Space\ntake damage upon entering. gold drops on this square doubled."
	static player_action = function(_player) {
		lives -= 1;
		audio_play_sound(snd_hurt, 10, false)
	}
	
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN, GOLD_MAX)*2
	}
}

function OrangeSpace() : Space() constructor {
	color = c_orange;
	shifted_color = shift_val(color);
	num_items = 0;
	items = array_create(num_items, noone)
	descr = "Orange Space\nobtain a free item. gold drops on this square halved."
	static player_action = function(_player) {
		if (array_contains(_player.inventory, noone)) {
			var _item_type = obj_spincard.items_list[irandom_range(0, array_length(obj_spincard.items_list)-1)];
			var _new_item = new _item_type();
			array_set(_player.inventory, array_get_index(_player.inventory, noone), _new_item)
			obj_spincard.calibrate_inventory();
		}
	}
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
	static player_action = function(_player) {
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