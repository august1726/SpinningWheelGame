// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function Space() constructor {
	type = 0;
	descr = "Space"
	colors = c_white;
	num_items = 1;
	items = array_create(num_items, noone)
	coins = 0;
	num_pointers = 0;
	idx = 0;
	static collect_coins = function(_player) {
		_player.coins += coins;
		coins = 0;
	}
	static player_action = function(_player, _spaces = noone) {
		
	}
	static spin_action = function() {
		repeat(num_pointers) {
			pointer_action();
		}
	}
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN, GOLD_MAX)
	}
	static stock_items = function(_reset_items) {
		for (var _i = 0; _i < array_length(items); _i++) {
			if(items[_i] == noone or _reset_items) {
				var _item_type = obj_spincard.random_item();
				items[_i] = new _item_type(is_instanceof(self, OrangeSpace) && _i == 0);
			}
		}
	}
}

function RedSpace() : Space() constructor {
	colors = [c_red];
	descr = "Red Space\ntake damage upon entering. gold drops on this square doubled."
	static player_action = function(_player, _spaces = noone) {
		_player.take_damage();
	}
	
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN, GOLD_MAX)*2
	}
}

function OrangeSpace() : Space() constructor {
	colors = c_orange;
	num_items = 1;
	items = array_create(num_items, noone)
	descr = "Orange Space\ncontains one free item. gold drops on this square halved."
	static pointer_action = function() {
		coins += irandom_range(GOLD_MIN/2, GOLD_MAX/2);
	}
}

function YellowSpace() : Space() constructor {
	colors = c_yellow;
	num_items = 2;
	items = array_create(num_items, noone)
	descr = "Yellow Space\ncontains 1 extra item for sale"
}

function GreenSpace() : Space() constructor {
	colors = c_green;
	descr = "Green Space\ngain 1 health upon entering if health is 2 or less."
	static player_action = function(_player, _spaces = noone) {
		if (lives <= HEAL_MAX) {
			lives += 1;
			audio_play_sound(snd_heal, 10, false);
		}
	}
}

function BlueSpace() : Space() constructor {
	colors = c_blue;
	descr = "Blue Space\nsee all dangerous spaces for next turn"
	static player_action = function(_player) {
		_player.vision = true;
	}
}

function PurpleSpace() : Space() constructor {
	colors = c_purple;
	descr = "Purple Space\ntravel up to 2 adjacent spaces, rather than just 1"
	static player_action = function(_player) {
		_player.movement = 2;
	}
}

function GreySpace() : Space() constructor {
	colors = c_grey;
	descr = "Disable Space:\n Only blight can be used on this space."
}

function HospitalSpace() : Space() constructor {
	colors = [c_red, c_white, c_green];
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
	colors = c_fuchsia;
	num_items = 0;
	items = array_create(num_items, noone)
	descr = "Double Space:\n Items used on this space will be activated again on the following turn."
}

function IntangibleSpace() : Space() constructor {
	colors = [c_navy, c_blue, c_red];
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
	colors = [c_red, c_orange, c_yellow, c_green, c_blue, c_purple, c_white];
	num_items = 0;
	items = array_create(num_items, noone)
	descr = "Choice Space:\n Gives an item which allows choosing between two spaces."
	static player_action = function(_player, _spaces) {
		
		if (array_contains(_player.inventory, noone)) {
			var _choice = new Choice(true);
			_choice.use_action(_player, _spaces)
			array_set(_player.inventory, array_get_index(_player.inventory, noone), _choice)
			obj_spincard.calibrate_inventory();
		}
		
	}
}

function FreezeSpace() : Space() constructor {
	colors = [c_white, c_teal];
	num_items = 1;
	items = array_create(num_items, noone)
	descr = "Freeze Space:\n While on space, pointers will not activate, and turn counter will not progress. Item buffs will still ware off."
}

function SwapSpace() : Space() constructor {
	colors = [c_lime, c_olive, c_olive, c_lime]
	num_items = 1;
	items = array_create(num_items, noone)
	descr = "Swap Space:\n Swaps position with another randoms space after leaving."
	static player_action = function(_player, _spaces) {
		_player.swap_space = self
	}
}

function AccumulateSpace() : Space() constructor {
	colors = [c_white, c_red, c_blue, c_green]
	num_items = 0;
	items = array_create(num_items, noone)
	descr = "Accumulate Space:\n This space is changed into another space upon item use. Items used in this space have an increased probability of showing up on the board."
	static player_action = function(_player, _spaces) {
		_player.accumulate = true
	}
}