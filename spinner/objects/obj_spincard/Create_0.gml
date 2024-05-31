#macro SPACING 32
#macro GOLD_MIN 2
#macro GOLD_MAX 4
#macro HEAL_MAX 2
#macro UNIT 32
#macro LINE_LENGTH (5.5*UNIT)
randomise()

gamemode = GAMEMODES.NORMAL;
player = new Player();

start_types = array_create(0);
spaces_list = array_create(0);

switch(gamemode) {
	case GAMEMODES.TUTORIAL:
		win_threshold = 20
		spaces_list = [YellowSpace, OrangeSpace, DoubleSpace, GreenSpace, BlindSpace];
		items_list = [HealthUp, AddSpace, Vision, Delay, Choice];
		num_start_spaces = 5;
		num_start_pointers = 3;
		max_spaces = 15
		start_types = array_shuffle(spaces_list);
		array_resize(start_types, num_start_spaces)
	break
	case GAMEMODES.NORMAL:
		win_threshold = 40
		spaces_list = [RedSpace, OrangeSpace, YellowSpace, GreenSpace, BlueSpace, PurpleSpace];
		items_list = [HealthUp, AddSpace, AddSpace, Jetpack, Vision, Reroll, Delay];
		num_start_spaces = 5;
		num_start_pointers = 1;
		max_spaces = 30
		start_types = array_shuffle(spaces_list);
		array_resize(start_types, num_start_spaces)
	break
	case GAMEMODES.CRAZY:
		win_threshold = 60
		spaces_list = [RedSpace, OrangeSpace, YellowSpace, GreenSpace, BlueSpace, PurpleSpace, GreySpace, HospitalSpace, DoubleSpace, IntangibleSpace, FreezeSpace]
		items_list = [HealthUp, AddSpace, Jetpack, Vision, Reroll, Delay, Blight, Magnet];
		num_start_spaces = 8;
		num_start_pointers = 1;
		max_spaces = 45
		start_types = array_shuffle(spaces_list);
		array_resize(start_types, num_start_spaces)
		array_push(spaces_list, BlindSpace);
	break
}

turn_num = 0;
in_play = true

spaces = array_create(num_start_spaces, noone)
for (var _i = 0; _i < num_start_spaces; _i++) {
	spaces[_i] = new start_types[_i]();
	spaces[_i].stock_items();
}

space = noone;
mouse_space = 0;

num_lines = 360*1.5;
section = 360 / array_length(spaces)
pointer_dirs = array_create(num_start_pointers)
warning_list = [];

mouse_dist  = 0;

lives = 3

shop_card = [];
for (var _i = 0; _i < instance_number(obj_shop_card); ++_i;)
{
    shop_card[_i] = instance_find(obj_shop_card, _i);
	shop_card[_i].player = player;
	shop_card[_i].item = noone;
}

item_slot = [];
for (var _i = 0; _i < instance_number(obj_item_slot); ++_i;)
{
    item_slot[_i] = instance_find(obj_item_slot, _i);
	item_slot[_i].i = _i;
}

function is_full(_element, _index)
{
    return _element != noone;
}

function calibrate_shop() {
	var _space_items = spaces[player.space].items
	var _items_for_sale = array_filter(_space_items, is_full)
	var _num_items = array_length(_items_for_sale)
	
	var _x = obj_shop_center.x - (3/2)*(_num_items-1)*UNIT;
	
	for (var _i = 0; _i < array_length(_space_items); _i++ ) {
		shop_card[_i].space_inventory = _space_items
		if (_i < _num_items) {
			shop_card[_i].item = _items_for_sale[_i]
			shop_card[_i].x = _x
			_x += 3*UNIT;
		} else {
			shop_card[_i].item = noone;
		}
	}
	show_debug_message("Calibrating Shop")
}

function clear_shop() {
	for (var _i = 0; _i < instance_number(obj_shop_card); ++_i;) {
	    shop_card[_i].item = noone;
	}	
}

function calibrate_inventory() {
	for (var _i = 0; _i < instance_number(obj_item_slot); ++_i;) {
		item_slot[_i].item  = player.inventory[_i];
	}
	show_debug_message("Calibrating Inventory")
}

function use_item(_i) {
	var _item_used = false;
	if (is_instanceof(spaces[player.space], GreySpace)) {
		if (is_struct(player.inventory[_i]) and is_instanceof(player.inventory[_i], Blight)) {
			_item_used = true;
		}
	} else {
		if (is_instanceof(spaces[player.space], DoubleSpace)) {
			array_push(player.repeat_items, player.inventory[_i])
		}
		player.inventory[_i].use_action(player, spaces);
		_item_used = true;
	}
	
	if (_item_used) {
		audio_play_sound(snd_use, 10, false)
		if (!is_instanceof(player.inventory[_i], Choice)) {
			array_set(player.inventory, _i, noone)
		} else {
			_item_used = false;	
		}
	}
	
	show_debug_message(player.inventory);
	return _item_used;
}

function n() {
	return array_length(spaces);
}

function add_space(_idx, _space) {
	array_insert(spaces, _idx, _space)
}

function remove_space(_idx) {
	array_delete(spaces, _idx, 1)
}

enum STATES {
	CHOOSE_START,
	INITIATE_TURN, 
	PLAYER_TURN,
	SPIN,
	WAIT,
	DEATH,
	WIN	
}

enum GAMEMODES {
	TUTORIAL,
	NORMAL,
	CRAZY
}

state_scrs = [choose_start, initiate_turn, player_turn, spin, wait, death, win];
state_descrs = ["Choose Start", "Player Turn", "Player Turn", "Pointer turn", "Pointer Turn", "Death", "Win"];

state = STATES.CHOOSE_START;

function show_pointers() {
	warning_list = []
	for (var _i = 0; _i < array_length(pointer_dirs); _i++) {
		var _space_idx = get_triangle_space(pointer_dirs[_i], section, array_length(spaces))
		if (!array_contains(warning_list, _space_idx) and player.sight_prob == 1) {
			array_push(warning_list, _space_idx);
		}
	}
}

draw_set_font(fnt_default)


audio_play_sound(snd_mus_main, 10, true)

addspace = new AddSpace(true)