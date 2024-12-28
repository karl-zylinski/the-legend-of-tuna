package game

import b2 "box2d"
import rl "vendor:raylib"
import "base:runtime"
import "core:encoding/json"
import "core:os"
import "core:fmt"

PIXEL_WINDOW_HEIGHT :: 180

Game_Memory :: struct {
	physics_world: b2.WorldId,
	rc: Round_Cat,
	lc: Long_Cat,
	walls: [dynamic]Wall,
	atlas: rl.Texture2D,

	editing: bool,
	es: Editor_State,
}

atlas: rl.Texture2D
g_mem: ^Game_Memory

refresh_globals :: proc() {
	atlas = g_mem.atlas
}

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {
		zoom = h/PIXEL_WINDOW_HEIGHT*10,
		target = vec2_flip(round_cat_pos(g_mem.rc)),
		offset = { w/2, h/2 },
	}
}

physics_world :: proc() -> b2.WorldId {
	return g_mem.physics_world
}

custom_context: runtime.Context

Level :: struct {
	walls: []Rect,
}

dt: f32

update :: proc() {
	dt = rl.GetFrameTime()

	if rl.IsKeyPressed(.F2) {
		if g_mem.editing {
			level := Level {
				walls = make([]Rect, len(g_mem.walls), context.temp_allocator),
			}

			for w, i in g_mem.walls {
				level.walls[i] = w.rect
			}

			marshal_options := json.Marshal_Options {
				pretty = true,
				spec = .SJSON,
			}
			
			json_data, json_marshal_err := json.marshal(level, marshal_options, context.temp_allocator)

			if json_marshal_err == nil {
				if !os.write_entire_file("level.sjson", json_data) {
					fmt.println("error writing level")
				}
			}
		}

		g_mem.editing = !g_mem.editing
	}

	if g_mem.editing {
		editor_update(&g_mem.es)
		return
	}

	custom_context = context
	b2.World_Step(physics_world(), 1/60.0, 4)

	long_cat_update(&g_mem.lc)
	round_cat_update(&g_mem.rc)
}

COLOR_WALL :: rl.Color { 16, 220, 117, 255 }

draw_world :: proc() {
	long_cat_draw(g_mem.lc)
	round_cat_draw(g_mem.rc)

	for &w in g_mem.walls {
		rl.DrawRectanglePro(rect_flip(w.rect), {0, 0}, 0, COLOR_WALL)	
	}
}

draw :: proc() {
	//debug_draw()
	if g_mem.editing {
		editor_draw(g_mem.es)
	} else {
		rl.BeginDrawing()
		rl.ClearBackground({0, 120, 153, 255})
		rl.BeginMode2D(game_camera())

		draw_world()

		rl.EndMode2D()
		rl.EndDrawing()
	}
}

get_world_mouse_pos :: proc(cam: rl.Camera2D) -> Vec2 {
	return vec2_flip(rl.GetScreenToWorld2D(rl.GetMousePosition(), cam))
}

get_mouse_pos :: proc() -> Vec2 {
	return vec2_flip(rl.GetMousePosition())
}

rect_flip :: proc(r: Rect) -> Rect {
	return {
		r.x, -r.y - r.height,
		r.width, r.height,
	}
}

vec2_flip :: proc(p: Vec2) -> Vec2 {
	return {
		p.x, -p.y,
	}
}

init_window :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "The Legend of Tuna")
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(500)
}

Vec2 :: [2]f32
Rect :: rl.Rectangle
GRAVITY :: Vec2 {0, -9.82*10}

Wall :: struct {
	body: b2.BodyId,
	shape: b2.ShapeId,
	rect: Rect,
}

WORLD_SCALE :: 10.0

make_wall :: proc(r: Rect) {
	w := Wall {
		rect = r,
	}

	ground_body_def := b2.DefaultBodyDef()
	ground_body_def.position = b2.Vec2{r.x + r.width/2, r.y + r.height/2}
	w.body = b2.CreateBody(physics_world(), ground_body_def)

	ground_box := b2.MakeBox((r.width/2), (r.height/2))
	ground_shape_def := b2.DefaultShapeDef()
	ground_shape_def.friction = 0.7
	w.shape = b2.CreatePolygonShape(w.body, ground_shape_def, ground_box)

	append(&g_mem.walls, w)
}

delete_wall :: proc(w: Wall) {
	b2.DestroyShape(w.shape)
	b2.DestroyBody(w.body)
}

ATLAS_DATA :: #load("../atlas.png")

init :: proc() {
	g_mem = new(Game_Memory)
	atlas_image := rl.LoadImageFromMemory(".png", raw_data(ATLAS_DATA), i32(len(ATLAS_DATA)))

	g_mem^ = Game_Memory {
		atlas = rl.LoadTextureFromImage(atlas_image),
	}

	rl.UnloadImage(atlas_image)

	world_def := b2.DefaultWorldDef()
	world_def.gravity = GRAVITY
	g_mem.physics_world = b2.CreateWorld(world_def)

	if data, data_ok := os.read_entire_file("level.sjson", context.temp_allocator); data_ok {
		level: Level
		json_unmarshal_err := json.unmarshal(data, &level, .SJSON, context.temp_allocator)

		if json_unmarshal_err == nil {
			for w in level.walls {
				make_wall(w)
			}
		}
	}

	g_mem.rc = round_cat_make()
	g_mem.lc = long_cat_make({4, 1.1})

	game_hot_reloaded(g_mem)
}

shutdown :: proc() {
	delete(g_mem.walls)
	free(g_mem)
}

shutdown_window :: proc() {
	rl.CloseWindow()
}

