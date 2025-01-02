#+build freestanding

package game

import "base:runtime"
import "core:log"
import "core:fmt"
import "core:strings"
import "core:c"
import rl "vendor:raylib"

custom_context: runtime.Context

@(export)
game_init :: proc "c" () {
	context = custom_context
	init()
}

@(export)
game_init_window :: proc "c" () {
	context = create_wasm_context()
	custom_context = context
	init_window()
}

@(export)
game_update :: proc "c" () {
	context = custom_context
	update()
	draw()

	free_all(context.temp_allocator)
}

@(export)
game_window_size_changed :: proc "c" (w, h: c.int) {
	rl.SetWindowSize(w, h)
}

@(export)
game_shutdown :: proc() {
	shutdown()
}

@(export)
game_shutdown_window :: proc() {
	shutdown_window()
}

@(export)
game_memory :: proc() -> rawptr {
	return g_mem
}

@(export)
game_memory_size :: proc() -> int {
	return size_of(Game_Memory)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
	g_mem = (^Game_Memory)(mem)
	refresh_globals()
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}

@(private="file")
create_wasm_context :: proc "contextless" () -> runtime.Context {
    c: runtime.Context = runtime.default_context()
    c.allocator = rl.MemAllocator()

    // Should we just also make it rl.MemAllocator()??
    c.temp_allocator.procedure = rl.MemAllocatorProc
    c.temp_allocator.data = nil

    context = c
    c.logger = create_wasm_logger()

    return c
}

Wasm_Logger_Opts :: log.Options{.Level, .Short_File_Path, .Line}

@(private="file")
create_wasm_logger :: proc (lowest := log.Level.Debug, opt := Wasm_Logger_Opts) -> log.Logger {
	return log.Logger{data = nil, procedure = wasm_logger_proc, lowest_level = lowest, options = opt}
}

@(private="file")
wasm_logger_proc :: proc(
	logger_data: rawptr,
	level: log.Level,
	text: string,
	options: log.Options,
	location := #caller_location,
) {
	puts(fmt.ctprint(text))
}

Level_Headers := [?]string {
	0 ..< 10 = "[DEBUG] --- ",
	10 ..< 20 = "[INFO ] --- ",
	20 ..< 30 = "[WARN ] --- ",
	30 ..< 40 = "[ERROR] --- ",
	40 ..< 50 = "[FATAL] --- ",
}

@(private="file")
do_level_header :: proc(options: log.Options, buf: ^strings.Builder, level: log.Level) {
	fmt.sbprintf(buf, Level_Headers[level])
}

@(private="file")
do_location_header :: proc(opts: log.Options, buf: ^strings.Builder, location := #caller_location) {
	if log.Location_Header_Opts & opts == nil {
		return
	}
	fmt.sbprint(buf, "[")
	file := location.file_path
	if .Short_File_Path in opts {
		last := 0
		for r, i in location.file_path {
			if r == '/' {
				last = i + 1
			}
		}
		file = location.file_path[last:]
	}

	if log.Location_File_Opts & opts != nil {
		fmt.sbprint(buf, file)
	}
	if .Line in opts {
		if log.Location_File_Opts & opts != nil {
			fmt.sbprint(buf, ":")
		}
		fmt.sbprint(buf, location.line)
	}

	if .Procedure in opts {
		if (log.Location_File_Opts | {.Line}) & opts != nil {
			fmt.sbprint(buf, ":")
		}
		fmt.sbprintf(buf, "%s()", location.procedure)
	}

	fmt.sbprint(buf, "] ")
}

@(default_calling_convention = "c")
foreign {
	puts :: proc(buffer: cstring) -> c.int ---
}