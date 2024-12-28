package game

import rl "vendor:raylib"

RAD2DEG :: rl.RAD2DEG

draw_dest_rect :: proc(pos: Vec2, source: Rect) -> Rect {
	return {
		pos.x, -pos.y,
		source.width/GAME_SCALE, source.height/GAME_SCALE,
	}
}

dest_rect :: proc(pos: Vec2, source: Rect) -> Rect {
	return {
		pos.x, -pos.y,
		source.width/GAME_SCALE, source.height/GAME_SCALE,
	}
}