package game

import "base:intrinsics"

remap :: proc "contextless" (old_value, old_min, old_max, new_min, new_max: $T) -> (x: T) where intrinsics.type_is_numeric(T), !intrinsics.type_is_array(T) {
	old_range := old_max - old_min
	new_range := new_max - new_min
	if old_range == 0 {
		return new_range / 2
	}
	return clamp(((old_value - old_min) / old_range) * new_range + new_min, new_min, new_max)
}