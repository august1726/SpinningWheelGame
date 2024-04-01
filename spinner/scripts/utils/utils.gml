// assumes that a and b are integers within 0 to wrap length
function get_wrap_dist(_a, _b, _n) {
	if (_a > _b) {
		return min(_a - _b, _n - (_a - _b));
	} else if (_a < _b) {
		return min(_b - _a, _n - (_b - _a));
	} else {
		return 0;	
	}
}

function shift_val(_col) {
	return make_color_hsv(color_get_hue(_col), color_get_saturation(_col), color_get_value(_col) / 3);
}

function get_random_space(_space1, _space2) {
	start = false;
	space_type = GreySpace;
	while (!start or is_instanceof(_space1, space_type) or is_instanceof(_space2, space_type)) {
		space_type = obj_spincard.spaces_list[irandom_range(0, array_length(obj_spincard.spaces_list)-1)];
		start = true;
	}
	return new space_type();
};