precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

void main() {
    vec4 color = texture2D(sTexture, vTextureCoord);
    if (color.r == 0 && color.g == 0 && color.b == 0) {
        color.a = 0;
    }
	gl_FragColor = color;
}
