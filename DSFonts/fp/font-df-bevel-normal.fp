varying lowp vec2 var_texcoord0;
varying lowp vec4 var_face_color;
varying lowp vec4 var_outline_color;
varying lowp vec4 var_shadow_color;
varying lowp vec4 var_sdf_params;
varying lowp vec4 var_layer_mask;

uniform mediump sampler2D texture_sampler;

uniform lowp vec4 step;

// https://codepen.io/actarian/pen/XRrgOm?editors=0010
vec4 bevel_normal() {
	mediump vec2 pixel = vec2(1.0 / 512.0);	
	mediump vec4 luma = vec4(0.5, 0.5, 0.5, 0.5);
	for(float i = 1.0; i < 3.0; i++) {
		luma.x += (texture2D(texture_sampler, var_texcoord0 + pixel * vec2(0.0, -1.0) * i)).x / i;
		luma.y += (texture2D(texture_sampler, var_texcoord0 + pixel * vec2(0.0, 1.0) * i)).x / i;
		luma.z += (texture2D(texture_sampler, var_texcoord0 + pixel * vec2(-1.0, 0.0) * i)).x / i;
		luma.w += (texture2D(texture_sampler, var_texcoord0 + pixel * vec2(1.0, 0.0) * i)).x / i;
	}
	lowp float horizontal = ((luma.z - luma.w) + 1.0) * 0.5;
	lowp float vertical = ((luma.x - luma.y) + 1.0) * 0.5;
	return vec4(horizontal, vertical, 1.0, 1.0);
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

	gl_FragColor = face_alpha * var_face_color * var_layer_mask.x * bevel_normal() +
	outline_alpha * var_outline_color * var_layer_mask.y * (1.0 - face_alpha * sdf_is_single_layer) +
	shadow_alpha * var_shadow_color * var_layer_mask.z * (1.0 - min(1.0,outline_alpha + face_alpha) * sdf_is_single_layer);
}
