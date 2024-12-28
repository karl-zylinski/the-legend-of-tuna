package game

import b2 "box2d"
import rl "vendor:raylib"
import "core:fmt"
import "core:c"

debug_draw :: proc() {
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