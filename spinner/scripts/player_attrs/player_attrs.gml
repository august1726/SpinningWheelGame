// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Player() constructor {
	def_movement = 1;
	movement = 1;
	space = 0;
	inventory = array_create(2, noone)
	coins = 0;
	countdown_length = 5;
	next_ptr = countdown_length;
	intangible = 0;
	vision = false;
	inspect = false;
	shell = false;
	insurance = false;
	reset_items = false;
	repeat_items = array_create(0)
	static reset_countdown = function() {
		next_ptr = countdown_length;
	}
	static use_repeats = function(_player, _spaces) {
		if (array_length(repeat_items) > 0) {
			audio_play_sound(snd_use, 10, false)
		}
		while (array_length(repeat_items) > 0) {
			array_shift(repeat_items).use_action(_player, _spaces);
		}
	}
	function subtract_intangible() {
		if (intangible > 0) {
			intangible--;	
		}
	}
	function take_damage() {
		if (intangible == 0) {
			lives--;
			if (!audio_is_playing(snd_hurt)) {
				audio_play_sound(snd_hurt, 10, false)
			}
		}
	}
	
	function take_pointer_damage(_damage) {
		
		if (shell) {
			if (_damage >= 1)
				_damage = 1;
		}
			
		if (insurance) {
			if (_damage >= 1)
				_damage -= 1;
		}
		
		if (intangible >= 1)
			_damage = 0;
		
		if (_damage >= 1 and !audio_is_playing(snd_hurt)) {
			audio_play_sound(snd_hurt, 10, false)
		}
		
		lives -= _damage;
	}
	
	function remove_choice() {
		for (var _i = 0; _i < array_length(inventory); _i++) {
			if (is_struct(inventory[_i]) and is_instanceof(inventory[_i], Choice)) {
				inventory[_i] = noone;
				obj_spincard.calibrate_inventory();
			}
		}
	}
	function reset_attributes() {
		vision = false;
		inspect = false;
		shell = false;
		insurance = false;
		reset_items = false;
		movement = def_movement;
	}
}