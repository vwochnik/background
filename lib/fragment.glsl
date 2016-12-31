#define M_PI 3.14159265358979323846
#define M_SQRT2 1.41421356237309504880
#define N_BLOCKS 5

precision mediump float;

uniform vec2 resolution;
uniform float time;

float rand(float x)
{
    return fract(sin(x) * 4358.5453123);
}

float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5357);
}

float star(vec2 p, float r)
{
  vec2 q = abs(p);
  float f = 0.7;
  return pow(pow(q.x, f) + pow(q.y, f), 1.0/f) - 0.2;
}

float plus(vec2 p, float r)
{
  float t = (0.5 + 0.5 * cos(4.0 * atan(p.y, p.x)));
  t = t<0.5 ? 2.0*t*t : -1.0+(4.0-2.0*t)*t;
  return length(abs(p)) - 2.0 * r * (0.5+0.5*t);
}

float circle(vec2 p, float r)
{
  return length(abs(p))-0.2;
}

float box(vec2 p, vec2 b, float r)
{
  return length(max(abs(p)-(1.5*b),0.0))-r;
}

float shape(vec2 p, float s, float r)
{
    if (r <= 0.25) {
        return box(p, vec2(s*(0.9+0.2*r),s*(1.1-0.2*r)), 0.125*s);
    }
    if(r <= 0.5) {
        return circle(p, s);
    }
    if (r <= 0.75) {
        return star(p, s);
    } else {
      return plus(p, s);
    }
}

vec2 edge(float a)
{
  float x = M_SQRT2 * sin(a*2.0*M_PI);
  float y = M_SQRT2 * cos(a*2.0*M_PI);
  return max(vec2(-1.0, -1.0), min(vec2(1.0, 1.0), vec2(x, y)));
}

void main()
{
	const float speed = 0.2;
	const float ySpread = 1.6;
    const float travelTime = 0.3;

	float pulse = 0.5 + 0.5 * sin(0.2 * time) * (0.9 + 0.1 * rand(time));
    pulse = 1.0;

    float aspect = resolution.x / resolution.y;
	vec2 uv = gl_FragCoord.xy / resolution - 0.5;
    uv.x *= aspect;
	vec3 baseColor = vec3(0.0,0.3, 0.6);

	vec3 color = vec3(0.0, 0.0, 0.0);

	for (int i = 0; i < N_BLOCKS; ++i)
	{
		float z = 1.0-0.7*rand(float(i)*1.4333); // 0=far, 1=near
		float tickTime = time*z*speed + float(i)*1.23753;

        float tickTravel = mod(tickTime, travelTime);
        vec2 pos1 = edge(rand(tickTime - tickTravel));
        vec2 pos2 = edge(rand(tickTime - tickTravel + 1.23753));
        float x = tickTravel / travelTime;

		float tick = floor(tickTime);

		//vec2 pos = vec2(pos1.x*(1.0-x)+pos2.x*x, pos1.y*(1.0-x)+pos2.y*x);
    vec2 pos = pos1 * (1.0 - x) + pos2 * x;
        pos.x *= aspect;

		float size = 0.1*z;
		//float b = shape(uv-pos, size, rand(tickTime - tickTravel));
		float b = circle(uv-pos, size);
		float dust = z*smoothstep(0.22, 0.0, b)*pulse*0.5;
		float block = 0.2*z*smoothstep(0.002, 0.0, b);
		float shine = 0.6*z*pulse*smoothstep(-0.002, b, 0.007);
		color += dust*baseColor + block*z + shine;
	}

	color += rand(uv)*0.04;
	gl_FragColor = vec4(color, 1.0);
}
