#+build freestanding
package game

import "core:encoding/json"

LEVEL_0 :: #load("../level.sjson")
LEVEL_1 :: #load("../level2.sjson")
LEVEL_2 :: #load("../level3.sjson")

load_level_data :: proc(level_name: string) -> (Level, bool) {
	data: []u8

	if level_name == "level.sjson" {
		data = LEVEL_0
	} else if level_name == "level1.sjson" {
		data = LEVEL_1
	} else if level_name == "level2.sjson" {
		data = LEVEL_2
	} else {
		return {}, false
	}

	level: Level

	json_unmarshal_err := json.unmarshal(data, &level, .SJSON, context.temp_allocator)

	if json_unmarshal_err != nil {
		return {}, false
	}

	return level, true
}

save_level_data :: proc(level_name: string, level: Level) {
	
}