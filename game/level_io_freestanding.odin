#+build freestanding
package game

import "core:encoding/json"

LEVEL_0 :: #load("../level.sjson")
LEVEL_1 :: #load("../level2.sjson")
LEVEL_2 :: #load("../level3.sjson")

level_data := [?][]u8 {
	LEVEL_0,
	LEVEL_1,
	LEVEL_2,
}

load_level_data :: proc(level_idx: int) -> (Level, bool) {
	if level_idx < 0 || level_idx >= len(level_data) {
		return {}, false
	}

	data := level_data[level_idx]
	level: Level
	json_unmarshal_err := json.unmarshal(data, &level, .SJSON, context.temp_allocator)

	if json_unmarshal_err != nil {
		return {}, false
	}

	return level, true
}

save_level_data :: proc(level_idx: int, level: Level) {
	
}