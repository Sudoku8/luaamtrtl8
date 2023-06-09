texture textureBack;
texture textureFore;
texture textureMask;

sampler samplerBack = sampler_state { texture = <textureBack>; MinFilter = LINEAR; MagFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };
sampler samplerFore = sampler_state { texture = <textureFore>; MinFilter = LINEAR; MagFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };
sampler samplerMask = sampler_state { texture = <textureMask>; MinFilter = LINEAR; MagFilter = LINEAR; AddressU = Clamp; AddressV = Clamp; };

float  alpha;
float3 colorMultiply;
float  maskTransitionVague;
float  maskTransitionStep;
float  red;
float  green;
float  blue;

const float3 graydata = float3(0.298912, 0.586611, 0.114478);

void vs(float4 position : POSITION, float2 texCoord0 : TEXCOORD0, float2 texCoord1 : TEXCOORD1, out float4 resultPosition : POSITION, out float2 resultTexCoord0 : TEXCOORD0, out float2 resultTexCoord1 : TEXCOORD1)
{
	resultPosition  = position;
	resultTexCoord0 = texCoord0;
	resultTexCoord1 = texCoord1;
}

void ps(float2 texCoord0 : TEXCOORD0, float2 texCoord1 : TEXCOORD1, out float4 result : COLOR0)
{
	float4 fore = tex2D(samplerFore, texCoord1);

	float gray = dot(fore.rgb, graydata);
	fore.r  = gray + 0.037;
	fore.g  = gray + 0.012;
	fore.b  = gray;// * blue;
	fore.a *= alpha;

	result = fore;
}

technique technique0
{
	pass p0
	{
		VertexShader     = compile vs_2_0 vs();
		PixelShader      = compile ps_3_0 ps();
		CullMode         = NONE;
		ZEnable          = false;
		AlphaBlendEnable = true;
	}
}
