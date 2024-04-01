/// @description Insert description here
// You can write your code in this editor
draw_set_color(c_ltgrey)
if (col == c_orange or col == c_yellow) {
	draw_rectangle(x, y, x + sprite_width, y + sprite_height, true);
} else {
	draw_rectangle(x, y, x + sprite_width, y + sprite_height, false);
}

draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_text_ext_color(x + sprite_width/2, y + sprite_height/2, text, 15, sprite_width, col, col, col, col, 1)







