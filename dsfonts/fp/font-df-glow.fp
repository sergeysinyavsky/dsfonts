varying lowp vec2 var_texcoord0;
varying lowp vec4 var_face_color;
varying lowp vec4 var_outline_color;
varying lowp vec4 var_shadow_color;
varying lowp vec4 var_sdf_params;
varying lowp vec4 var_layer_mask;

uniform mediump sampler2D texture_sampler;

uniform lowp vec4 texture_size_recip;

// float outer_strength = 0.0;
// float inner_strength = 5.0;
// float quality = 0.1;
// float distance = 2.0;
uniform vec4 strength;
uniform vec4 glow_color;

// https://codepen.io/mishaa/pen/raKzrm?editors=0010
vec4 glow(float alpha) {
	vec2 px = vec2(1.0 / (strength.z * 100.0));
	vec4 ownColor = vec4(var_face_color) * alpha;
	vec4 curColor;
	float totalAlpha = 0.0;
	float maxTotalAlpha = 0.0;
	float cosAngle;
	float sinAngle;
	for (float angle = 0.0; angle <= 6.28; angle += 1.0) {
		cosAngle = cos(angle);
		sinAngle = sin(angle);
		for (float curDistance = 1.0; curDistance <= 10.0; curDistance++) {
			curColor = texture2D(texture_sampler, vec2(var_texcoord0.x + cosAngle * curDistance * px.x, var_texcoord0.y + sinAngle * curDistance * px.y));
			totalAlpha += (10.0 - curDistance) * curColor.x;
			maxTotalAlpha += (10.0 - curDistance);
		}
	}
	maxTotalAlpha = max(maxTotalAlpha, 0.0001);

	ownColor.a = max(ownColor.a, 0.0001);
	ownColor.rgb = ownColor.rgb / ownColor.a;
	float outerGlowAlpha = (totalAlpha / maxTotalAlpha)  * strength.x * (1.0 - ownColor.a);
	float innerGlowAlpha = ((maxTotalAlpha - totalAlpha) / maxTotalAlpha) * strength.y * ownColor.a;
	float resultAlpha = (ownColor.a + outerGlowAlpha);
	return vec4(mix(mix(ownColor.rgb, glow_color.rgb, innerGlowAlpha / ownColor.a), glow_color.rgb, outerGlowAlpha / resultAlpha) * resultAlpha, resultAlpha);
}

void main()
{
	mediump vec4 sample = texture2D(texture_sampler, var_texcoord0);

	mediump float distance        = sample.x;
	mediump float distance_shadow = sample.z;

	lowp float sdf_edge      = var_sdf_params.x;
	lowp float sdf_outline   = var_sdf_params.y;
	lowp float sdf_smoothing = var_sdf_params.z;
	lowp float sdf_shadow    = var_sdf_params.w;

	// If there is no blur, the shadow should behave in the same way as the outline.
	lowp float sdf_shadow_as_outline = floor(sdf_shadow);
	// If this is a single layer font, we must make sure to not mix alpha between layers.
	lowp float sdf_is_single_layer   = var_layer_mask.a;

	lowp float face_alpha      = smoothstep(sdf_edge - sdf_smoothing, sdf_edge + sdf_smoothing, distance);
	lowp float outline_alpha   = smoothstep(sdf_outline - sdf_smoothing, sdf_outline + sdf_smoothing, distance);
	lowp float shadow_alpha    = smoothstep(sdf_shadow - sdf_smoothing, sdf_edge + sdf_smoothing, distance_shadow);

	shadow_alpha = mix(shadow_alpha,outline_alpha,sdf_shadow_as_outline);
	
	gl_FragColor = glow(outline_alpha) * var_layer_mask.x +
	outline_alpha * var_outline_color * var_layer_mask.y * (1.0 - face_alpha * sdf_is_single_layer) +
	shadow_alpha * var_shadow_color * var_layer_mask.z * (1.0 - min(1.0,outline_alpha + face_alpha) * sdf_is_single_layer);
	// gl_FragColor = var_face_color * distance;
}
