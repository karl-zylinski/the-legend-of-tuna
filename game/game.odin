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
	won_at: f64,

	background_shader: rl.Shader,
	ground_shader: rl.Shader,

	current_level: int,
	finished: bool,
}

/*Tile :: struct {
	tile: Tile_Id,
	pos: [2]int,
}*/

current_level_name :: proc() -> string {
	if g_mem.current_level < len(levels) {
		return levels[g_mem.current_level]
	}

	return ""
}

levels := [?]string {
	"level.sjson",
	"level2.sjson",
	"level3.sjson",
}

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
		target = vec2_flip(round_cat_pos(g_mem.rc) + {0, 1.5}),
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

Level_Wall :: struct {
	rect: Rect,
	rot: f32,
}

Level :: struct {
	walls: []Level_Wall,
	tuna_pos: Vec2,
	starting_pos: Vec2,
}

dt: f32
real_dt: f32

got_tuna :: proc() {
	g_mem.won = true
	g_mem.won_at = rl.GetTime()
}

update :: proc() {
	dt = rl.GetFrameTime()
	real_dt = dt

	if rl.IsKeyPressed(.ESCAPE) {
		rl.CloseWindow()
	}

	if g_mem.finished {
		return
	}

	if g_mem.won {
		dt = 0

		if rl.IsMouseButtonPressed(.LEFT) && g_mem.won_at + 0.5 > rl.GetTime() {
			g_mem.won = false

			if g_mem.current_level == len(levels) - 1 {
				g_mem.finished = true
				g_mem.won_at = rl.GetTime()
			} else {
				load_level(g_mem.current_level + 1)	
			}
		}
	}

	if rl.IsKeyPressed(.F2) {
		if g_mem.editing {
			level := Level {
				walls = make([]Level_Wall, len(g_mem.walls), context.temp_allocator),
				tuna_pos = g_mem.tuna,
				starting_pos = g_mem.starting_pos,
			}

			for w, i in g_mem.walls {
				level.walls[i].rect = w.rect
				level.walls[i].rot = w.rot
			}

			marshal_options := json.Marshal_Options {
				pretty = true,
				spec = .SJSON,
			}
			
			json_data, json_marshal_err := json.marshal(level, marshal_options, context.temp_allocator)

			if json_marshal_err == nil {
				c := current_level_name()

				if c != "" {
					if !os.write_entire_file(current_level_name(), json_data) {
						fmt.println("error writing level")
					}
				}
			}
		}

		g_mem.editing = !g_mem.editing
	}

	if g_mem.editing {
		editor_update(&g_mem.es)
		return
	}


	when ODIN_DEBUG {
		if rl.IsKeyPressed(.ONE) {
			load_level(0)
		}

		if rl.IsKeyPressed(.TWO) {
			load_level(1)
		}

		if rl.IsKeyPressed(.THREE) {
			load_level(2)
		}
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
		if (g_mem.lc.state == .Done || g_mem.lc.state == .Not_Spawned) {
			g_mem.long_cat_spawns += 1

			if g_mem.lc.state == .Done {
				long_cat_delete(g_mem.lc)
			}

			g_mem.lc = long_cat_make(get_world_mouse_pos(game_camera()))
		}
	}

	if round_cat_pos(g_mem.rc).y < 300 {
		load_level(g_mem.current_level)
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

	rl.BeginShaderMode(g_mem.ground_shader)

	for &w in g_mem.walls {
		mid := Vec2 {w.rect.width/2, w.rect.height/2}
		rl.DrawRectanglePro(rect_offset(rect_flip(w.rect), mid), mid, -w.rot*RAD2DEG, COLOR_WALL)
	}

	rl.EndShaderMode()
	
	long_cat_draw(g_mem.lc)
}

draw :: proc() {
	//debug_draw()
	if g_mem.editing {
		editor_draw(g_mem.es)
	} else {
		rl.BeginDrawing()
		time_loc := rl.GetShaderLocation(g_mem.background_shader, "time")

		camera_pos_loc := rl.GetShaderLocation(g_mem.background_shader, "cameraPos")
		t := f32(rl.GetTime())
		rl.SetShaderValue(g_mem.background_shader, time_loc, &t, .FLOAT)
		game_cam := game_camera()
		rl.SetShaderValue(g_mem.background_shader, camera_pos_loc, &game_cam.target, .VEC2)
		rl.BeginShaderMode(g_mem.background_shader)

		rl.DrawRectangleRec({0, 0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}, rl.WHITE)
		//rl.ClearBackground({0, 120, 153, 255})
		rl.EndShaderMode()
		rl.BeginMode2D(game_cam)

		draw_world()

		rl.EndMode2D()
		rl.BeginMode2D(ui_camera())

		rl.DrawText(fmt.ctprintf("%v", g_mem.long_cat_spawns), 10, PIXEL_WINDOW_HEIGHT - 30, 20, rl.WHITE)

		if g_mem.finished {
			rl.DrawText("YOU DID IT!! YOU FOUND\nTHE THREE MAGICAL\nTUNA CANS!!!\n\nGOOD BYE", 40, 40, 20, rl.WHITE)
		} else if g_mem.won {
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
	rot: f32,
}

WORLD_SCALE :: 10.0

make_wall :: proc(r: Rect, rot: f32) {
	w := Wall {
		rect = r,
		rot = rot,
	}

	body_def := b2.DefaultBodyDef()
	body_def.position = b2.Vec2{r.x + r.width/2, r.y + r.height/2}
	body_def.rotation = b2.MakeRot(rot)
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

delete_current_level :: proc() {
	if g_mem.physics_world != {} {
		b2.DestroyWorld(g_mem.physics_world)
	}
	delete(g_mem.walls)
}

Vec3 :: [3]f32

load_level :: proc(level_idx: int) -> bool {
	delete_current_level()

	g_mem.current_level = level_idx
	current_level_name := current_level_name()

	if current_level_name == "" {
		return false
	}

	color1_loc := rl.GetShaderLocation(g_mem.ground_shader, "groundColor1")
	color2_loc := rl.GetShaderLocation(g_mem.ground_shader, "groundColor2")
	color3_loc := rl.GetShaderLocation(g_mem.ground_shader, "groundColor3")
	
	c1 := Vec3 {0.44, 0.69, 0.3}
	c2 := Vec3 {0.2, 0.37, 0.15}
	c3 := Vec3 {0.3, 0.15, 0.13}

	if level_idx == 1 {
		c1 = {0.5, 0.49, 0.2}
		c2 = {0.77, 0.4, 0.15}
		c3 = {0.15, 0.3, 0.3}
	}

	if level_idx == 2 {
		c1 = {0.7, 0.3, 0.3}
		c2 = {0.4, 0.4, 0.5}
		c3 = {0.2, 0.1, 0.2}
	}

	rl.SetShaderValue(g_mem.ground_shader, color1_loc, &c1, .VEC3)
	rl.SetShaderValue(g_mem.ground_shader, color2_loc, &c2, .VEC3)
	rl.SetShaderValue(g_mem.ground_shader, color3_loc, &c3, .VEC3)

	world_def := b2.DefaultWorldDef()
	world_def.gravity = GRAVITY
	world_def.enableContinous = true
	g_mem.physics_world = b2.CreateWorld(world_def)

	g_mem.walls = {}
	g_mem.long_cat_spawns = 0

	if data, data_ok := os.read_entire_file(current_level_name, context.temp_allocator); data_ok {
		level: Level
		json_unmarshal_err := json.unmarshal(data, &level, .SJSON, context.temp_allocator)

		if json_unmarshal_err == nil {
			for w in level.walls {
				make_wall(w.rect, w.rot)
			}

			g_mem.tuna = level.tuna_pos
			g_mem.starting_pos = level.starting_pos
		}
	}

	g_mem.rc = round_cat_make(g_mem.starting_pos)
	g_mem.lc.state = .Not_Spawned
	return true
}


init :: proc() {
	g_mem = new(Game_Memory)
	atlas_image := rl.LoadImageFromMemory(".png", raw_data(ATLAS_DATA), i32(len(ATLAS_DATA)))

	g_mem^ = Game_Memory {
		atlas = rl.LoadTextureFromImage(atlas_image),
		tuna = {10, -2},
		background_shader = rl.LoadShader(nil, "bg_shader.glsl"),
		ground_shader = rl.LoadShader("ground_shader_vs.glsl", "ground_shader.glsl"),
	}

	rl.UnloadImage(atlas_image)

	load_level(0)

	game_hot_reloaded(g_mem)
}

shutdown :: proc() {
	delete(g_mem.walls)
	free(g_mem)
}

shutdown_window :: proc() {
	rl.CloseWindow()
}

