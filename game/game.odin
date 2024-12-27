package game

import "core:fmt"
import "core:math/linalg"
import b2 "../box2d"
import rl "vendor:raylib"

PIXEL_WINDOW_HEIGHT :: 180

Game_Memory :: struct {
	physics_world: b2.WorldId,
	player_body: b2.BodyId,
	walls: [dynamic]Wall,

}

g_mem: ^Game_Memory

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {
		zoom = h/PIXEL_WINDOW_HEIGHT,
		target = vec2_flip(player_pos()),
		offset = { w/2, h/2 },
	}
}

player_pos :: proc() -> Vec2 {
	return b2.Body_GetPosition(g_mem.player_body)
}

physics_world :: proc() -> b2.WorldId {
	return g_mem.physics_world
}

update :: proc() {
	b2.World_Step(physics_world(), 1/60.0, 4)
}

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	rl.BeginMode2D(game_camera())
	rl.DrawCircleV(vec2_flip(player_pos()), 10, rl.WHITE)

	for &w in g_mem.walls {
		rl.DrawRectanglePro(rect_flip(w.rect), {0, w.rect.height}, 0, rl.GREEN)	
	}
	
	rl.EndMode2D()

	rl.EndDrawing()
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

@(export)
game_update :: proc() -> bool {
	update()
	draw()
	return !rl.WindowShouldClose()
}

@(export)
game_init_window :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "The Legend of Tuna")
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(500)
}

Vec2 :: [2]f32
Rect :: rl.Rectangle
GRAVITY :: Vec2 {0, -9.82*10}

GROUND :: Rect {
	-20, -40,
	200, 10,
}

Wall :: struct {
	body: b2.BodyId,
	shape: b2.ShapeId,
	rect: Rect,
}

make_wall :: proc(r: Rect) {
	w := Wall {
		rect = r,
	}

	ground_body_def := b2.DefaultBodyDef()
	ground_body_def.position = b2.Vec2{r.x, r.y}
	w.body = b2.CreateBody(physics_world(), ground_body_def)

	ground_box := b2.MakeBox(r.width, r.height)
	ground_shape_def := b2.DefaultShapeDef()
	w.shape = b2.CreatePolygonShape(w.body, ground_shape_def, ground_box)

	append(&g_mem.walls, w)
}

@(export)
game_init :: proc() {
	g_mem = new(Game_Memory)

	g_mem^ = Game_Memory {
	}

	world_def := b2.DefaultWorldDef()
	world_def.gravity = GRAVITY
	g_mem.physics_world = b2.CreateWorld(world_def)

	player_body_def := b2.DefaultBodyDef()
	player_body_def.type = .dynamicBody
	player_body_def.position = {0, 0}
	g_mem.player_body = b2.CreateBody(g_mem.physics_world, player_body_def)

	shape_def := b2.DefaultShapeDef()
	shape_def.density = 1000
	shape_def.friction = 0.3

	circle: b2.Circle
	circle.radius = 10
	_ = b2.CreateCircleShape(g_mem.player_body, shape_def, circle)

	make_wall(GROUND)

	make_wall({
		60, -100,
		10, 200,
	})

	game_hot_reloaded(g_mem)
}

@(export)
game_shutdown :: proc() {
	free(g_mem)
}

@(export)
game_shutdown_window :: proc() {
	rl.CloseWindow()
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
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}
