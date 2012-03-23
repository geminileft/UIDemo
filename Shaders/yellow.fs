precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

void main() {
    vec4 color = texture2D(sTexture, vTextureCoord);
    color.g = color.r;
    gl_FragColor = color;
}
