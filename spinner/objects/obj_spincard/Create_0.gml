#macro SPACING 32
#macro GOLD_MIN 2
#macro GOLD_MAX 4
#macro HEAL_MAX 2
#macro NUM_START_SPACES 5
#macro WIN_THRESHOLD 40
#macro UNIT 32
randomise()

spaces_list = [RedSpace, OrangeSpace, YellowSpace, GreenSpace, BlueSpace, PurpleSpace]
items_list = [HealthUp, AddSpace, AddSpace, Jetpack, Vision, Reroll, Delay];
start_types = array_shuffle(spaces_list);
array_resize(start_types, NUM_START_SPACES)

turn_num = 0;
in_play = true

spaces = array_create(NUM_START_SPACES)
for (var _i = 0; _i < NUM_START_SPACES; _i++) {
	spaces[_i] = new start_types[_i](_i);
	spaces[_i].stock_items();
}

space = noone;

num_lines = 360*1.5;
line_length = 5.5*UNIT
section = 360 / array_length(spaces)
pointer_dirs = array_create(1)
warning_list = [];

mouse_dist  = 0;
player = new Player();

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

function calibrate_inventory() {
	for (var _i = 0; _i < instance_number(obj_item_slot); ++_i;) {
		item_slot[_i].item  = player.inventory[_i];
	}
	show_debug_message("Calibrating")
}

function use_item(_i) {
	player.inventory[_i].use_action(player, spaces);
	array_set(player.inventory, _i, noone)
	show_debug_message(player.inventory);
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
state_scrs = [choose_start, initiate_turn, player_turn, spin, wait, death, win];
state_descrs = ["Choose Start", "Player Turn", "Player Turn", "Pointer turn", "Pointer Turn", "Death", "Win"];

state = STATES.CHOOSE_START;

function show_pointers() {
	warning_list = []
	for (var _i = 0; _i < array_length(pointer_dirs); _i++) {
		var _space_idx = pointer_dirs[_i] div section
		if (!array_contains(warning_list, _space_idx) and random(1) < player.sight_prob) {
			array_push(warning_list, _space_idx);
		}
	}
}
draw_set_font(fnt_default)


audio_play_sound(snd_mus_main, 10, true)