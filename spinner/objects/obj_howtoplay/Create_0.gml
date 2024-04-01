x1 = room_width/30
y1 = room_height/12
x2 = room_width - x1
y2 = room_height - y1

text = "Pick a space to start\nYou can move to adjacent spaces every turn\nHover over different spaces and power-ups to see what properties they have.\nPlayers can buy power-ups when on their space\nPrices of new power-ups are dependent on turn number and player's wealth.\nPower-ups and coins spawn on the space where a pointer lands\nIf a pointer lands on the player's space, they take 1 damage (per pointer)\nIf you reach 0 health, you lose\nIf you reach 40 rounds, you win\nThere is 1 pointer to begin with, and an additional pointer is added every 5 rounds"

button_half_width = 64;
button_height = 32;

button_x1 = room_width/2 - button_half_width
button_y1 = y2
button_x2 = room_width/2 + button_half_width
button_y2 = y2 + button_height

music = snd_mus_howto
audio_play_sound(music, 10, true)