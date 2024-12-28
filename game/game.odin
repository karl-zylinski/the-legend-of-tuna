package game

import "core:fmt"
import "core:math/linalg"
import b2 "../box2d"
import rl "vendor:raylib"
import "core:c"
import "base:runtime"

PIXEL_WINDOW_HEIGHT :: 180

Game_Memory :: struct {
	physics_world: b2.WorldId,
	player_body: b2.BodyId,
	player_shape: b2.ShapeId,
	walls: [dynamic]Wall,
	atlas: rl.Texture2D,
}

g_mem: ^Game_Memory

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {
		zoom = h/PIXEL_WINDOW_HEIGHT*10,
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

custom_context: runtime.Context

update :: proc() {
	custom_context = context
	b2.World_Step(physics_world(), 1/60.0, 4)

	if rl.IsMouseButtonPressed(.LEFT) {
		pp := player_pos()
		mp := get_world_mouse_pos()

		dist := pp - mp

		b2.Body_ApplyLinearImpulseToCenter(g_mem.player_body, dist*20, true)
		fmt.println(dist)
	}
}

COLOR_WALL :: rl.Color { 16, 220, 117, 255 }

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground({0, 120, 153, 255})

	rl.BeginMode2D(game_camera())

	r := b2.Body_GetRotation(g_mem.player_body)
	a := b2.Rot_GetAngle(b2.Body_GetRotation(g_mem.player_body))

	pp := vec2_flip(player_pos())

	source := atlas_textures[.Round_Cat].rect

	dest := Rect {
		pp.x, pp.y,
		source.width/10, source.height/10,
	}

	rl.DrawTexturePro(g_mem.atlas, source, dest, {dest.width/2, dest.height/2}, -a*rl.RAD2DEG, rl.WHITE)

	for &w in g_mem.walls {
		rl.DrawRectanglePro(rect_flip(w.rect), {0, w.rect.height}, 0, COLOR_WALL)	
	}

	dd := b2.DebugDraw {
		drawShapes = false,
		DrawSolidCapsule = debug_draw_solid_capsule,
		DrawPolygon = debug_draw_polygon,
		DrawSolidPolygon = debug_draw_solid_polygon,
		DrawCircle = debug_draw_circle,
		DrawSolidCircle = debug_draw_solid_circle,
		DrawSegment = debug_draw_segment,
	}
	
	b2.World_Draw(physics_world(), &dd)

	rl.EndMode2D()

	rl.EndDrawing()
}

debug_draw_solid_capsule :: proc "c" (p1, p2: Vec2, radius: f32, color: b2.HexColor, ctx: rawptr) {
	context = custom_context
	fmt.println(p1)
	rl.DrawCircleLinesV(p1, radius, rl.RED)
	rl.DrawCircleLinesV(p2, radius, rl.RED)
}

debug_draw_polygon :: proc "c" (vertices: [^]Vec2, vertexCount: c.int, color: b2.HexColor, ctx: rawptr) {
	context = custom_context
	fmt.println("hi")
}

debug_draw_solid_polygon :: proc "c" (transform: b2.Transform, vertices: [^]Vec2, vertexCount: c.int, radius: f32, colr: b2.HexColor, ctx: rawptr ) {
	context = custom_context
	fmt.println("hi")
}

debug_draw_circle :: proc "c" (center: Vec2, radius: f32, color: b2.HexColor, ctx: rawptr) {
	context = custom_context
	fmt.println("hi")
}

debug_draw_segment :: proc "c" (p1, p2: Vec2, color: b2.HexColor, ctx: rawptr) {
	context = custom_context
	fmt.println("hi")
}

debug_draw_solid_circle :: proc "c" (transform: b2.Transform, radius: f32, color: b2.HexColor, ctx: rawptr) {
	context = custom_context
	fmt.println("hi")
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

GROUND :: Rect {
	-2, -4,
	20, 1,
}

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

	player_body_def := b2.DefaultBodyDef()
	player_body_def.type = .dynamicBody
	player_body_def.position = {0, 0}
	g_mem.player_body = b2.CreateBody(g_mem.physics_world, player_body_def)

	shape_def := b2.DefaultShapeDef()
	shape_def.density = 1.5
	shape_def.friction = 0.3
	shape_def.restitution = 0.2

	capsule := b2.Capsule {
		center1 = {0, -0.2},
		center2 = {0, 0.2},
		radius = 1,
	}
	g_mem.player_shape = b2.CreateCapsuleShape(g_mem.player_body, shape_def, capsule)

	make_wall(GROUND)

	make_wall({
		6, -10,
		1, 20,
	})

	game_hot_reloaded(g_mem)
}

shutdown :: proc() {
	delete(g_mem.walls)
	free(g_mem)
}

shutdown_window :: proc() {
	rl.CloseWindow()
}