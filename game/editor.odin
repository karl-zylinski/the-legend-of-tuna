package game

import rl "vendor:raylib"
import b2 "box2d"
import "core:fmt"
import "core:math/linalg"

_ :: fmt

Editor_State :: struct {
	placing_box: bool,
	placing_start: Vec2,
	editor_camera_pos: Vec2,
	editor_camera_zoom: f32,
	moving_wall: Maybe(int),
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

	es.editor_camera_pos += linalg.normalize0(camera_movement) * 60 * real_dt

	cam := editor_camera(es^)

	if moving_wall_idx, moving_wall := es.moving_wall.?; moving_wall {
		mp := get_world_mouse_pos(cam)
		w := &g_mem.walls[moving_wall_idx]
		mid := Vec2 { w.rect.width / 2, w.rect.height / 2}
		w.rect.x = mp.x - mid.x
		w.rect.y = mp.y - mid.y
		t := b2.Body_GetTransform(w.body)
		b2.Body_SetTransform(w.body, mp, t.q)

		if rl.IsMouseButtonReleased(.LEFT) {
			es.moving_wall = nil
		}
	} else if es.placing_box {
		if rl.IsMouseButtonReleased(.LEFT) {
			b := editor_get_box(es^)

			if b.width != 0 && b.height != 0 {
				make_wall(b, 0)
			}
			
			es.placing_box = false
		}
	} else {
		if rl.IsMouseButtonPressed(.LEFT) {
			for &w, i in g_mem.walls {
				mp := get_world_mouse_pos(cam)
				p := b2.Shape_GetPolygon(w.shape)
				t := b2.Body_GetTransform(w.body)
				p = b2.TransformPolygon(t, p)

				if b2.PointInPolygon(mp, p) {
					es.moving_wall = i
					break
				}
			}	

			if es.moving_wall == nil {
				es.placing_box = true
				es.placing_start = get_world_mouse_pos(cam)
			}
		}

		if rl.IsKeyPressed(.ONE) {
			g_mem.starting_pos = get_world_mouse_pos(cam)
			b2.Body_SetTransform(g_mem.rc.body, g_mem.starting_pos, b2.MakeRot(0))
		}

		if rl.IsKeyPressed(.TWO) {
			g_mem.tuna = get_world_mouse_pos(cam)
		}

		if rl.IsMouseButtonPressed(.RIGHT) {
			for w, i in g_mem.walls {
				mp := get_world_mouse_pos(cam)

				if rl.CheckCollisionPointRec(mp, w.rect) {
					delete_wall(w)
					unordered_remove(&g_mem.walls, i)
					break
				}
			}	
		}

		if rl.IsKeyDown(.R) {
			for &w in g_mem.walls {
				mp := get_world_mouse_pos(cam)
				p := b2.Shape_GetPolygon(w.shape)
				t := b2.Body_GetTransform(w.body)
				p = b2.TransformPolygon(t, p)

				if b2.PointInPolygon(mp, p) {
					w.rot += rl.IsKeyDown(.LEFT_SHIFT) ? real_dt : -real_dt
					b2.Body_SetTransform(w.body, t.p, b2.MakeRot(w.rot))
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

			p := b2.Shape_GetPolygon(w.shape)
			p = b2.TransformPolygon(b2.Body_GetTransform(w.body), p)

			if b2.PointInPolygon(mp, p) {
				mid := Vec2 {w.rect.width/2, w.rect.height/2}
				rl.DrawRectanglePro(rect_offset(rect_flip(w.rect), mid), mid, -w.rot*RAD2DEG, {255, 0, 0, 120})
				break
			}
		}
	}

	rl.EndMode2D()
	rl.EndDrawing()
}

rect_offset :: proc(r: Rect, o: Vec2) -> Rect {
	return {
		r.x + o.x,
		r.y + o.y,
		r.width,
		r.height,
	}
}