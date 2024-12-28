package game

import rl "vendor:raylib"
import "core:fmt"
import "core:math/linalg"

_ :: fmt

Editor_State :: struct {
	placing_box: bool,
	placing_start: Vec2,
	editor_camera_pos: Vec2,
	editor_camera_zoom: f32,
}

editor_camera :: proc(es: Editor_State) -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {
		zoom = es.editor_camera_zoom,
		target = vec2_flip(es.editor_camera_pos),
		offset = { w/2, h/2 },
	}
}

editor_update :: proc(es: ^Editor_State) {
	if es.editor_camera_zoom < 0.1 {
		es.editor_camera_zoom = 1
	}

	mwm := rl.GetMouseWheelMove()

	if mwm != 0 {
		es.editor_camera_zoom += mwm
	}

	camera_movement: Vec2

	if rl.IsKeyDown(.W) {
		camera_movement.y += 1
	}

	if rl.IsKeyDown(.S) {
		camera_movement.y -= 1
	}

	if rl.IsKeyDown(.A) {
		camera_movement.x -= 1
	}

	if rl.IsKeyDown(.D) {
		camera_movement.x += 1
	}

	es.editor_camera_pos += linalg.normalize0(camera_movement) * 60 * dt

	if es.placing_box {
		if rl.IsMouseButtonReleased(.LEFT) {
			b := editor_get_box(es^)
			make_wall(b)
			es.placing_box = false
		}
	} else {
		if rl.IsMouseButtonPressed(.LEFT) {
			es.placing_box = true
			es.placing_start = get_world_mouse_pos(editor_camera(es^))
		}

		if rl.IsMouseButtonPressed(.RIGHT) {
			for w, i in g_mem.walls {
				mp := get_world_mouse_pos(editor_camera(es^))

				if rl.CheckCollisionPointRec(mp, w.rect) {
					delete_wall(w)
					unordered_remove(&g_mem.walls, i)
					break
				}
			}	
		}
	}
}

editor_get_box :: proc(es: Editor_State) -> Rect {
	s := es.placing_start
	mp := get_world_mouse_pos(editor_camera(es))
	diff := mp - s

	r := rect_from_pos_size(s, diff)

	if r.width < 0 {
		r.x += r.width
		r.width = -r.width
	}

	if r.height < 0 {
		r.y += r.height
		r.height = -r.height
	}

	return r
}

editor_draw :: proc(es: Editor_State) {
	rl.BeginDrawing()
	rl.ClearBackground({0, 120, 153, 255})
	rl.BeginMode2D(editor_camera(es))

	draw_world()

	if es.placing_box {
		rl.DrawRectangleRec(rect_flip(editor_get_box(es)), {255, 0, 0, 120})
	} else {

		for w in g_mem.walls {
			mp := get_world_mouse_pos(editor_camera(es))

			if rl.CheckCollisionPointRec(mp, w.rect) {
				rl.DrawRectangleRec(rect_flip(w.rect), {255, 0, 0, 120})
				break
			}
		}
	}

	rl.EndMode2D()
	rl.EndDrawing()
}