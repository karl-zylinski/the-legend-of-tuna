#+build !freestanding

package game

import "core:os"
import "core:path/filepath"

platform_init :: proc() {
	exe_path := os.args[0]
    exe_dir := filepath.dir(string(exe_path), context.temp_allocator)
    os.set_current_directory(exe_dir)
}
