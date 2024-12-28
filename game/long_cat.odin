package game

import rl "vendor:raylib"
import b2 "box2d"
import "core:math"
import "core:fmt"

_ :: fmt

Long_Cat :: struct {
	body: b2.BodyId,
	shape: b2.ShapeId,
	hinge_body: b2.BodyId,
	hinge_joint: b2.JointId,
}

long_cat_make :: proc() -> Long_Cat {
	bd := b2.DefaultBodyDef()
	bd.type = .dynamicBody
	bd.position = {4, 1}
	body := b2.CreateBody(g_mem.physics_world, bd)

	sd := b2.DefaultShapeDef()
	sd.density = 2
	sd.friction = 0.3
	sd.restitution = 0.7

	capsule := b2.Capsule {
		center1 = {0, -1.8},
		center2 = {0, 1.8},
		radius = 0.5,
	}

	shape := b2.CreateCapsuleShape(body, sd, capsule)

	hinge_body_def := b2.DefaultBodyDef()
	hinge_body_def.position = {4, 1.3}
	hinge_body_def.type = .staticBody
	hb := b2.CreateBody(g_mem.physics_world, hinge_body_def)

	hinge_joint_def := b2.DefaultRevoluteJointDef()
	hinge_joint_def.bodyIdA = hb
	hinge_joint_def.bodyIdB = body
	hinge_joint_def.localAnchorB = {0, 1.7}
	hinge_joint_def.collideConnected = false

	hinge_joint := b2.CreateRevoluteJoint(g_mem.physics_world, hinge_joint_def)
	b2.RevoluteJoint_EnableLimit(hinge_joint, true)

	return {
		body = body,
		shape = shape,
		hinge_body = hb,
		hinge_joint = hinge_joint,
	}
}

long_cat_update :: proc(lc: ^Long_Cat) {
	hbp := body_pos(lc.hinge_body)
	mp := get_world_mouse_pos()
	hinge_to_mouse := mp - hbp
	angle := -math.atan2(hinge_to_mouse.y, hinge_to_mouse.x) + math.PI/2

	if angle > math.PI {
		angle = angle-2*math.PI
	}

	fmt.println(angle)
	b2.RevoluteJoint_SetLimits(lc.hinge_joint, angle, angle)

	/*if rl.IsMouseButtonPressed(.LEFT) {
		pp := body_pos(lc.body)
		mp := get_world_mouse_pos()

		dist := pp - mp

		b2.Body_ApplyLinearImpulseToCenter(lc.body, dist*30, true)
	}*/
}

long_cat_draw :: proc(lc: Long_Cat) {
	pp := vec2_flip(body_pos(lc.body))
	source := atlas_textures[.Long_Cat].rect

	dest := Rect {
		pp.x, pp.y,
		source.width/10, source.height/10,
	}

	rl.DrawTexturePro(atlas, source, dest, {dest.width/2, dest.height/2}, body_angle_deg(lc.body), rl.WHITE)
}