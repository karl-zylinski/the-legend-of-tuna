package game

import b2 "box2d"

body_angle_deg :: proc(b: b2.BodyId) -> f32 {
	return -b2.Rot_GetAngle(b2.Body_GetRotation(b))*RAD2DEG
}

body_pos :: proc(b: b2.BodyId) -> Vec2 {
	return b2.Body_GetPosition(b)
}