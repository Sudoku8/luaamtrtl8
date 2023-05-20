varying vec2 resultCoord0;
varying vec2 resultCoord1;

uniform sampler2D textureBack;
uniform sampler2D textureFore;
uniform sampler2D textureMask;


uniform float  alpha;
uniform vec3 colorMultiply;
uniform float  maskTransitionVague;
uniform float  maskTransitionStep;
uniform float  red;
uniform float  green;
uniform float  blue;

const vec3 graydata = vec3(0.298912, 0.586611, 0.114478);


void main()
{
	vec4 fore = texture2D(textureFore, resultCoord1);

	float gray = dot(fore.rgb, graydata);
	fore.r  = gray + 0.037;
	fore.g  = gray + 0.012;
	fore.b  = gray;// * blue;
	fore.a *= alpha;

	gl_FragColor = fore;
}

