package game

import b2 "box2d"
import rl "vendor:raylib"
import "core:fmt"
import "core:math"

_ :: math
_ :: fmt

Round_Cat :: struct {
	body: b2.BodyId,
	shape: b2.ShapeId,
	squish_amount: f32,
	squish_direction: Vec2,
	squish_start: f64,
}

round_cat_make :: proc(pos: Vec2) -> Round_Cat {
	bd := b2.DefaultBodyDef()
	bd.type = .dynamicBody
	bd.position = pos
	bd.linearDamping = 0.2
	bd.angularDamping = 0.7
	body := b2.CreateBody(g_mem.physics_world, bd)

	sd := b2.DefaultShapeDef()
	sd.density = 1.5
	sd.friction = 0.3
	sd.restitution = 0.0
	sd.filter = {
		categoryBits = u32(bit_set[Collision_Category] { .Round_Cat }),
		maskBits = u32(bit_set[Collision_Category] { .Long_Cat, .Wall }),
	}

	capsule := b2.Capsule {
		center1 = {0, -0.2},
		center2 = {0, 0.2},
		radius = 1,
	}

	shape := b2.CreateCapsuleShape(body, sd, capsule)

	return {
		body = body,
		shape = shape,
	}
}

round_cat_pos :: proc(rc: Round_Cat) -> Vec2 {
	return body_pos(rc.body)
}


ease_peak :: proc(t: f32) -> f32 {
	return 64 * t * t * t * (1 - t) * (1 - t) * (1 - t)
}

ease_squish :: proc(t: f32) -> f32 {
	smoothstop := 1 - (1-t) * (1-t) * (1-t) * (1-t) * (1-t)
	return smoothstop
}

smoothstart5 :: proc(t: f32) -> f32 {
	return t * t * t * t * t
}

round_cat_draw :: proc(rc: Round_Cat) {
	a := b2.Rot_GetAngle(b2.Body_GetRotation(rc.body))
	source := atlas_textures[.Round_Cat].rect
	dest := draw_dest_rect(body_pos(rc.body), source)

	/*t := f32(remap(rl.GetTime(), rc.squish_start, rc.squish_start + 0.5, 0, 1))

	sq := math.lerp(rc.squish_direction * rc.squish_amount, Vec2{}, smoothstart5(t))

	dest.width *= 1-sq.x
	dest.height *= 1-sq.y
	dest.x += sq.x*2
	dest.y += sq.y*2

	// rlgl scale?*/

	rl.DrawTexturePro(atlas, source, dest, {dest.width/2, dest.height/2}, -a*rl.RAD2DEG, rl.WHITE)
}

round_cat_update :: proc(rc: ^Round_Cat) {
	tuna_circle := b2.Circle {
		center = g_mem.tuna,
		radius = 1,
	}

	tuna_circle_transf := b2.Transform {		
		p = tuna_circle.center,
	}

	coll := b2.CollideCapsuleAndCircle(b2.Shape_GetCapsule(rc.shape), b2.Body_GetTransform(rc.body), tuna_circle, tuna_circle_transf)

	if !g_mem.won && coll.pointCount > 0 {
		got_tuna()
	}

	contact_cap := b2.Body_GetContactCapacity(rc.body)
	contact_data := make([]b2.ContactData, contact_cap, context.temp_allocator)
	contact_data = b2.Body_GetContactData(rc.body, contact_data)

	for &c in contact_data {
		vel := c.manifold.points[0].normalVelocity

		if abs(vel) > 10 && c.shapeIdA != g_mem.lc.shape && c.shapeIdB != g_mem.lc.shape {
			rl.PlaySound(g_mem.land_sound)
		}
	}


	/*if rl.IsMouseButtonPressed(.LEFT) {
		pp := round_cat_pos(rc^)
		mp := get_world_mouse_pos()

		dist := pp - mp

		b2.Body_ApplyLinearImpulseToCenter(rc.body, dist*20, true)
	}*/
}
