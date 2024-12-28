package game

import rl "vendor:raylib"
import b2 "box2d"

Long_Cat :: struct {
	body: b2.BodyId,
	shape: b2.ShapeId,
}

long_cat_make :: proc() -> Long_Cat {
	bd := b2.DefaultBodyDef()
	bd.type = .dynamicBody
	bd.position = {4, 1}
	body := b2.CreateBody(g_mem.physics_world, bd)

	sd := b2.DefaultShapeDef()
	sd.density = 1.5
	sd.friction = 0.3
	sd.restitution = 0.2

	capsule := b2.Capsule {
		center1 = {0, -1.8},
		center2 = {0, 1.8},
		radius = 0.5,
	}

	shape := b2.CreateCapsuleShape(body, sd, capsule)

	hinge_body_def := b2.DefaultBodyDef()
	hinge_body_def.position = {4, 1.4}
	hinge_body_def.type = .staticBody
	hb := b2.CreateBody(g_mem.physics_world, hinge_body_def)

	hinge_joint_def := b2.DefaultRevoluteJointDef()
	hinge_joint_def.bodyIdA = hb
	hinge_joint_def.bodyIdB = body
	hinge_joint_def.localAnchorB = {0, 1.7}
	hinge_joint_def.collideConnected = false

	_ = b2.CreateRevoluteJoint(g_mem.physics_world, hinge_joint_def)

	return {
		body = body,
		shape = shape,
	}
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