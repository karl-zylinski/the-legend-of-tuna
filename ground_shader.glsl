#version 100

precision highp float;

varying vec3 localPosition;

uniform vec3 groundColor1;
uniform vec3 groundColor2;
uniform vec3 groundColor3;

// from https://github.com/FarazzShaikh/glNoise/blob/master/src/Perlin.glsl

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
vec2 _fade(vec2 t) { return t * t * t * (t * (t * 6.0 - 15.0) + 10.0); }
vec3 _fade(vec3 t) { return t * t * t * (t * (t * 6.0 - 15.0) + 10.0); }

/**
 * Generates 2D Perlin Noise.
 *
 * @name gln_perlin
 * @function
 * @param {vec2} p  Point to sample Perlin Noise at.
 * @return {float}  Value of Perlin Noise at point "p".
 *
 * @example
 * float n = gln_perlin(position.xy);
 */
vec4 gln_rand4(vec4 p) { return mod(((p * 34.0) + 1.0) * p, 289.0); }

float gln_perlin(vec2 P) {
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = gln_rand4(gln_rand4(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x, gy.x);
  vec2 g10 = vec2(gx.y, gy.y);
  vec2 g01 = vec2(gx.z, gy.z);
  vec2 g11 = vec2(gx.w, gy.w);
  vec4 norm =
      1.79284291400159 - 0.85373472095314 * vec4(dot(g00, g00), dot(g01, g01),
                                                 dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = _fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

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
    vec2 i = (floor((localPosition.xy*100.0)/10.0)*10.0);
	float n = gln_perlin(i/500.0);
    float nn = gln_simplex(i/400.0);
    n -= nn;
	vec3 c1 = groundColor1;//vec3(0.44, 0.69, 0.3);
	vec3 c2 = groundColor2;//vec3(0.2f, 0.37f, 0.15f);
    vec3 c3 = groundColor3;//vec3(0.3f, 0.15f, 0.13f);
    vec4 finalColor = vec4(mix(c2, c3, step(n, 0.5)).rgb, 1.0);
	finalColor = vec4(mix(finalColor.rgb, c1, step(n, 0.2)).rgb,1.0);
    gl_FragColor = finalColor;
}
