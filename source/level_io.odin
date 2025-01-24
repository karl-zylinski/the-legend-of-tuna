package game

import "core:encoding/json"
import "core:log"

load_level_data :: proc(level_idx: int) -> (Level, bool) {
	if level_idx < 0 || level_idx >= len(levels) {
		return {}, false
	}

	level_name := levels[level_idx]

	data, data_ok := read_entire_file(level_name, context.temp_allocator)

	if !data_ok {
		return {}, false
	}

	level: Level

	json_unmarshal_err := json.unmarshal(data, &level, .SJSON, context.temp_allocator)

	if json_unmarshal_err != nil {
		return {}, false
	}

	return level, true
}

save_level_data :: proc(level_idx: int, level: Level) {
	if level_idx < 0 || level_idx >= len(levels) {
		return
	}
	
	level_name := levels[level_idx]

	marshal_options := json.Marshal_Options {
		pretty = true,
		spec = .SJSON,
	}
	
	json_data, json_marshal_err := json.marshal(level, marshal_options, context.temp_allocator)

	if json_marshal_err == nil {
		if !write_entire_file(level_name, json_data) {
			log.error("error writing level")
		}
	}
}