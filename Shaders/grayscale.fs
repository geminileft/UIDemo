precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

void main() {
    vec4 color = texture2D(sTexture, vTextureCoord);
    float value = (color.r + color.g + color.b) / 3.0;
    color.r = value;
    color.g = value;
    color.b = value;
	gl_FragColor = color;
}
