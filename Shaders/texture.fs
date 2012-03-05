precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;
uniform float uAlpha;

void main() {
    vec4 color = texture2D(sTexture, vTextureCoord);
    color.a *= uAlpha;
	gl_FragColor = color;
}
