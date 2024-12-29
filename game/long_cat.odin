package game

import rl "vendor:raylib"
import b2 "box2d"
import "core:math"
import "core:fmt"

_ :: b2
_ :: fmt

Long_Cat_State :: enum {
	Placing,
	Charging,
	Swinging,
	Done,
	Not_Spawned,
}

Long_Cat :: struct {
	pos: Vec2,
	rot: f32,
	state: Long_Cat_State,

	body: b2.BodyId,
	shape: b2.ShapeId,
	hinge_body: b2.BodyId,
	hinge_joint: b2.JointId,

	swing_timeout: f32,
	swing_force: f32,
	swing_dir: f32,
	hit_round_cat: bool,
}

long_cat_enable_physics :: proc(lc: ^Long_Cat) {
	bd := b2.DefaultBodyDef()
	bd.type = .dynamicBody
	bd.angularDamping = 0.5
	bd.position = lc.pos - rl.Vector2Rotate({0, 1.7}, -lc.rot)
	bd.rotation = b2.MakeRot(-lc.rot)
	body := b2.CreateBody(g_mem.physics_world, bd)

	sd := b2.DefaultShapeDef()
	sd.density = 3
	sd.friction = 0.3
	sd.restitution = 0.7
	sd.filter = {
		categoryBits = u32(bit_set[Collision_Category] { .Long_Cat }),
		maskBits = u32(bit_set[Collision_Category] { .Round_Cat }),
	}

	capsule := b2.Capsule {
		center1 = {0, -1.9},
		center2 = {0, 1.9},
		radius = 0.5,
	}

	shape := b2.CreateCapsuleShape(body, sd, capsule)

	hinge_body_def := b2.DefaultBodyDef()
	hinge_body_def.position = lc.pos
	hinge_body_def.type = .staticBody
	hb := b2.CreateBody(g_mem.physics_world, hinge_body_def)

	hinge_joint_def := b2.DefaultRevoluteJointDef()
	hinge_joint_def.bodyIdA = hb
	hinge_joint_def.bodyIdB = body
	hinge_joint_def.localAnchorB = {0, 1.7}
	hinge_joint_def.collideConnected = false
	
	hinge_joint := b2.CreateRevoluteJoint(g_mem.physics_world, hinge_joint_def)

	lc.body = body
	lc.shape = shape
	lc.hinge_body = hb
	lc.hinge_joint = hinge_joint
}

long_cat_delete :: proc(lc: Long_Cat) {
	b2.DestroyJoint(lc.hinge_joint)
	b2.DestroyBody(lc.hinge_body)
	b2.DestroyShape(lc.shape)
	b2.DestroyBody(lc.body)
}

long_cat_make :: proc(pos: Vec2) -> Long_Cat {
	return {
		pos = pos,
	}
}

SWING_MAX_RAD :: 2.5

long_cat_update :: proc(lc: ^Long_Cat) {

	switch lc.state {
	case .Placing:
		mp := get_world_mouse_pos(game_camera())	
		lc.pos = mp + {0, 1}

		if rl.IsMouseButtonPressed(.LEFT) {
			lc.state = .Charging
		}

	case .Charging:
		mp := get_world_mouse_pos(game_camera())
		hinge_to_mouse := mp - lc.pos
		angle := math.atan2(hinge_to_mouse.y, hinge_to_mouse.x) + math.PI/2

		if angle > math.PI {
			angle = angle-2*math.PI
		}

		angle = clamp(angle, -SWING_MAX_RAD, SWING_MAX_RAD)

		shake_amount: f32

		if angle > 0 {
			shake_amount = remap(angle, 1, 2, 0, 0.15)
		} else {
			shake_amount = remap(angle, -1, -2, 0, 0.15)
		}

		lc.rot = -angle + f32(math.cos(rl.GetTime()*100))*shake_amount*shake_amount

		if rl.IsMouseButtonPressed(.LEFT) {
			lc.state = .Swinging
			long_cat_enable_physics(lc)
			lc.swing_force = abs(lc.rot)
			lc.swing_dir = math.sign(lc.rot)
			b2.Body_ApplyAngularImpulse(lc.body, lc.rot*500, true)
			lc.swing_timeout = 2
		}

	case .Swinging:
		contact_cap := b2.Body_GetContactCapacity(lc.body)
		contact_data := make([]b2.ContactData, contact_cap, context.temp_allocator)
		contact_data = b2.Body_GetContactData(lc.body, contact_data)
 	
 		if !lc.hit_round_cat {
			for &c in contact_data {
				a_is_rc := c.shapeIdA == g_mem.rc.shape
				b_is_rc := c.shapeIdB == g_mem.rc.shape
				if a_is_rc || b_is_rc {
					lc.swing_force = 0
					lc.hit_round_cat = true
					rl.PlaySound(g_mem.hit_sound)
					break
				}
			}
		}

		if !lc.hit_round_cat {
			b2.Body_SetLinearVelocity(g_mem.rc.body, {})
			b2.Body_SetAngularVelocity(g_mem.rc.body, 0)
		}

		b2.Body_ApplyTorque(lc.body, lc.swing_force * lc.swing_dir * 2000, true)

		lc.swing_timeout -= rl.GetFrameTime()

		if lc.swing_timeout <= 0 {
			lc.state = .Done
		}

	case .Done:

	case .Not_Spawned:
	}
}

long_cat_draw :: proc(lc: Long_Cat) {
	source := atlas_textures[.Long_Cat].rect

	switch lc.state {
	case .Placing:
		dest := draw_dest_rect(lc.pos, source)
		rl.DrawTexturePro(atlas, source, dest, {dest.width/2, dest.height/2-1.7}, lc.rot*RAD2DEG, rl.WHITE)
	case .Charging:
		dest := draw_dest_rect(lc.pos, source)

		c := rl.RED
		t := abs(lc.rot)/SWING_MAX_RAD
		c.a = u8(remap(t*t, 0, 1, 90, 150))

		rl.DrawCircleSector(vec2_flip(lc.pos), 3.7, 90, lc.rot*RAD2DEG+90, 10, c)

		rl.DrawTexturePro(atlas, source, dest, {dest.width/2, dest.height/2-1.7}, lc.rot*RAD2DEG, rl.WHITE)
	case .Swinging:
		dest := draw_dest_rect(body_pos(lc.body), source)
		rl.DrawTexturePro(atlas, source, dest, {dest.width/2, dest.height/2}, body_angle_deg(lc.body), rl.WHITE)

	case .Done:
		dest := draw_dest_rect(body_pos(lc.body), source)
		rl.DrawTexturePro(atlas, source, dest, {dest.width/2, dest.height/2}, body_angle_deg(lc.body), rl.WHITE)

	case .Not_Spawned:
	}	
}