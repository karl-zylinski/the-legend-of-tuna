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
	starting_pos: Vec2,
	rc: Round_Cat,
	lc: Long_Cat,
	tuna: Vec2,
	walls: [dynamic]Wall,
	//tiles: [dynamic]Tile,
	atlas: rl.Texture2D,

	editing: bool,
	es: Editor_State,
	time_accumulator: f32,

	long_cat_spawns: int,
	won: bool,

	background_shader: rl.Shader,
}

/*Tile :: struct {
	tile: Tile_Id,
	pos: [2]int,
}*/

atlas: rl.Texture2D
g_mem: ^Game_Memory

refresh_globals :: proc() {
	atlas = g_mem.atlas
}

GAME_SCALE :: 10

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {
		zoom = h/PIXEL_WINDOW_HEIGHT*GAME_SCALE,
		target = vec2_flip(round_cat_pos(g_mem.rc)),
		offset = { w/2, h/2 },
	}
}

ui_camera :: proc() -> rl.Camera2D {
	return {
		zoom = f32(rl.GetScreenHeight())/PIXEL_WINDOW_HEIGHT,
	}
}

physics_world :: proc() -> b2.WorldId {
	return g_mem.physics_world
}

custom_context: runtime.Context

Level :: struct {
	walls: []Rect,
	tuna_pos: Vec2,
	starting_pos: Vec2,
}

dt: f32
real_dt: f32

update :: proc() {
	dt = rl.GetFrameTime()
	real_dt = dt

	if g_mem.won {
		dt = 0
	}

	if rl.IsKeyPressed(.F2) {
		if g_mem.editing {
			level := Level {
				walls = make([]Rect, len(g_mem.walls), context.temp_allocator),
				tuna_pos = g_mem.tuna,
				starting_pos = g_mem.starting_pos,
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

	g_mem.time_accumulator += dt

	PHYSICS_STEP :: 1/60.0

	for g_mem.time_accumulator >= PHYSICS_STEP {
		b2.World_Step(physics_world(), PHYSICS_STEP, 4)	
		g_mem.time_accumulator -= PHYSICS_STEP
	}

 	long_cat_update(&g_mem.lc)
	round_cat_update(&g_mem.rc)

	if rl.IsMouseButtonPressed(.LEFT) {
		if (g_mem.lc.state == .Done || g_mem.lc.state == .Not_Spawned) && g_mem.long_cat_spawns > 0 {
			g_mem.long_cat_spawns -= 1

			if g_mem.lc.state == .Done {
				long_cat_delete(g_mem.lc)
			}

			g_mem.lc = long_cat_make(get_world_mouse_pos(game_camera()))
		}
	}
}

Collision_Category :: enum u32 {
	Wall,
	Long_Cat,
	Round_Cat,
}

COLOR_WALL :: rl.Color { 16, 220, 117, 255 }

draw_world :: proc() {
	{
		tuna_source := atlas_textures[.Tuna].rect
		dest := draw_dest_rect(g_mem.tuna, tuna_source)
		rl.DrawTexturePro(atlas, tuna_source, dest, {dest.width/2, dest.height/2}, 0, rl.WHITE)
	}

	round_cat_draw(g_mem.rc)

	for &w in g_mem.walls {
		rl.DrawRectanglePro(rect_flip(w.rect), {0, 0}, 0, COLOR_WALL)	
	}
	
	long_cat_draw(g_mem.lc)
}

draw :: proc() {
	//debug_draw()
	if g_mem.editing {
		editor_draw(g_mem.es)
	} else {
		rl.BeginDrawing()
		time_loc := rl.GetShaderLocation(g_mem.background_shader, "time")
		t := f32(rl.GetTime())
		rl.SetShaderValue(g_mem.background_shader, time_loc, &t, .FLOAT)
		rl.BeginShaderMode(g_mem.background_shader)



		rl.DrawRectangleRec({0, 0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}, rl.WHITE)
		//rl.ClearBackground({0, 120, 153, 255})
		rl.EndShaderMode()
		rl.BeginMode2D(game_camera())

		draw_world()

		rl.EndMode2D()
		rl.BeginMode2D(ui_camera())

		rl.DrawText(fmt.ctprintf("%v", g_mem.long_cat_spawns), 10, PIXEL_WINDOW_HEIGHT - 30, 20, rl.WHITE)

		if g_mem.won {
			rl.DrawText("YAY!!! TUNA", 40, 40, 40, rl.WHITE)
		}

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

	body_def := b2.DefaultBodyDef()
	body_def.position = b2.Vec2{r.x + r.width/2, r.y + r.height/2}
	w.body = b2.CreateBody(physics_world(), body_def)

	box := b2.MakeBox((r.width/2), (r.height/2))
	shape_def := b2.DefaultShapeDef()
	shape_def.friction = 0.7
	shape_def.filter = {
		categoryBits = u32(bit_set[Collision_Category] { .Wall }),
		maskBits = u32(bit_set[Collision_Category] { .Round_Cat, .Long_Cat }),
	}

	w.shape = b2.CreatePolygonShape(w.body, shape_def, box)
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
		long_cat_spawns = 9,
		tuna = {10, -2},
		background_shader = rl.LoadShader(nil, "bg_shader.glsl"),
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

			g_mem.tuna = level.tuna_pos
			g_mem.starting_pos = level.starting_pos
		}
	}

	g_mem.rc = round_cat_make(g_mem.starting_pos)
	g_mem.lc.state = .Not_Spawned

	game_hot_reloaded(g_mem)
}

shutdown :: proc() {
	delete(g_mem.walls)
	free(g_mem)
}

shutdown_window :: proc() {
	rl.CloseWindow()
}

