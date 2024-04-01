// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Player() constructor {
	def_movement = 1;
	movement = 1;
	space = 0;
	inventory = array_create(2, noone)
	sight_prob = 0;
	coins = 0;
	countdown_length = 5;
	next_ptr = countdown_length;
	static reset_movement = function() {
		movement = def_movement;
	}
	static reset_countdown = function() {
		next_ptr = countdown_length;
	}
}