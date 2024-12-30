#version 100

precision highp float;

uniform float time;
uniform vec2 cameraPos;


// from https://github.com/FarazzShaikh/glNoise/blob/master/src/Simplex.glsl

/**
 * Generates 2D Simplex Noise.
 *
 * @name gln_simplex
 * @function
 * @param {vec2} v  Point to sample Simplex Noise at.
 * @return {float}  Value of Simplex Noise at point "p".
 *
 * @example
 * float n = gln_simplex(position.xy);
 */

vec3 gln_rand3(vec3 p) { return mod(((p * 34.0) + 1.0) * p, 289.0); }

float gln_simplex(vec2 v) {
	const vec4 C = vec4(0.211324865405187, 0.366025403784439, -0.577350269189626,
											0.024390243902439);
	vec2 i = floor(v + dot(v, C.yy));
	vec2 x0 = v - i + dot(i, C.xx);
	vec2 i1;
	i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	vec4 x12 = x0.xyxy + C.xxzz;
	x12.xy -= i1;
	i = mod(i, 289.0);
	vec3 p = gln_rand3(gln_rand3(i.y + vec3(0.0, i1.y, 1.0)) + i.x +
										 vec3(0.0, i1.x, 1.0));
	vec3 m = max(
			0.5 - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
	m = m * m;
	m = m * m;
	vec3 x = 2.0 * fract(p * C.www) - 1.0;
	vec3 h = abs(x) - 0.5;
	vec3 ox = floor(x + 0.5);
	vec3 a0 = x - ox;
	m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
	vec3 g;
	g.x = a0.x * x0.x + h.x * x0.y;
	g.yz = a0.yz * x12.xz + h.yz * x12.yw;
	return 130.0 * dot(m, g);
}

void main()
{
	vec2 sp = (floor(gl_FragCoord.xy/5.0)*5.0)/600.0;
	float n = gln_simplex(sp + vec2(time*1.2*0.01, time*0.01) + cameraPos*0.005);

	vec4 c1 = vec4(10.0/255.0, 130.0/255.0, 163.0/255.0, 1);
	vec4 c2 = vec4(0.0/255.0, 120.0/255.0, 153.0/255.0, 1);


	float s = (cos(time/10.0) + 1.0)/6.0+0.3;

	gl_FragColor = vec4(mix(c1, c2, step(n, s)).rgb,1);
}
// #name: Simplex
