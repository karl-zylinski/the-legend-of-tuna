package game

import b2 "box2d"
import rl "vendor:raylib"
import "base:runtime"

PIXEL_WINDOW_HEIGHT :: 180

Game_Memory :: struct {
	physics_world: b2.WorldId,
	rc: Round_Cat,
	lc: Long_Cat,
	walls: [dynamic]Wall,
	atlas: rl.Texture2D,
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

update :: proc() {
	custom_context = context
	b2.World_Step(physics_world(), 1/60.0, 4)

	long_cat_update(&g_mem.lc)
	round_cat_update(&g_mem.rc)
}

COLOR_WALL :: rl.Color { 16, 220, 117, 255 }

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground({0, 120, 153, 255})

	rl.BeginMode2D(game_camera())

	long_cat_draw(g_mem.lc)
	round_cat_draw(g_mem.rc)

	for &w in g_mem.walls {
		rl.DrawRectanglePro(rect_flip(w.rect), {0, w.rect.height}, 0, COLOR_WALL)	
	}

	//debug_draw()
	rl.EndMode2D()
	rl.EndDrawing()
}

get_world_mouse_pos :: proc() -> Vec2 {
	return vec2_flip(rl.GetScreenToWorld2D(rl.GetMousePosition(), game_camera()))
}

get_mouse_pos :: proc() -> Vec2 {
	return vec2_flip(rl.GetMousePosition())
}

rect_flip :: proc(r: Rect) -> Rect {
	return {
		r.x, -r.y,
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

	make_wall({
		-2, -4,
		20, 1,
	})

	/*make_wall({
		6, -10,
		1, 20,
	})*/

	g_mem.rc = round_cat_make()
	g_mem.lc = long_cat_make()

	game_hot_reloaded(g_mem)
}

shutdown :: proc() {
	delete(g_mem.walls)
	free(g_mem)
}

shutdown_window :: proc() {
	rl.CloseWindow()
}

