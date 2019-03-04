#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform vec4 u_colorOffset;

void main(void)
{
	vec4 color = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
	gl_FragColor = vec4(color.rgb + u_colorOffset.rgb * color.a, color.a);
}