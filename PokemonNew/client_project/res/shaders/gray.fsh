#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main(void)
{
	vec4 color = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
	gl_FragColor = vec4(
		color.r*0.2126+color.g*0.7152+color.b*0.0722,
		color.r*0.2126+color.g*0.7152+color.b*0.0722,
		color.r*0.2126+color.g*0.7152+color.b*0.0722,
		color.a
	);
}